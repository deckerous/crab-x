class_name Entity
extends CharacterBody2D

@export_group("Entity stats")
@export var max_hp: float = 10
@onready var hp: float = max_hp
@export var armor: int = 0
@export var health_bar_visible: bool = true
@export var entity_id: String = "unknown"

@onready var animations = $Animations
@onready var collision_box = $CollisionBox
@onready var hitbox_component = $HitboxComponent as HitboxComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var state_machine = $StateMachine
@onready var health_bar = $HealthBar
var health_bar_initial_pos = Vector2.ZERO

signal entity_died(node_name)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# State machine initialization
	state_machine.init(self, animations)
	
	hurtbox_component.hurt.connect(_damaged)
	health_bar.visible = false
	
	_update_health_bar()
	health_bar_initial_pos = health_bar.position
	health_bar.global_position = global_position + health_bar_initial_pos

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event) # state machine input update

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta) # state machine physics frame update
	
	health_bar.global_position = lerp(health_bar.global_position, global_position + health_bar_initial_pos, 0.25)

func _process(delta):
	state_machine.process_frame(delta) # state machine physics frame update

func summon_projectile(proj: Node2D, pos: Vector2) -> void:
	get_tree().root.add_child(proj)
	proj.global_position = pos

func _damaged(hitbox: HitboxComponent) -> void:
	hp = hp - max(0, hitbox.damage - armor)
	_update_health_bar()
	
	if hp <= 0:
		self.hide()
		self.process_mode = Node.PROCESS_MODE_DISABLED
		entity_died.emit(name)
		queue_free()

func _update_health_bar() -> void:
	if !health_bar_visible: return
	if hp < max_hp: health_bar.visible = true
	else: health_bar.visible = false
	health_bar.value = (hp / max_hp) * health_bar.max_value
