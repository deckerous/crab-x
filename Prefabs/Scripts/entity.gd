class_name Entity
extends CharacterBody2D

@export var hp: int = 10
@export var armor: int = 0

@onready var animations = $Animations
@onready var collision_box = $CollisionBox
@onready var hitbox_component = $HitboxComponent
@onready var hurtbox_component = $HurtboxComponent
@onready var state_machine = $StateMachine

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# State machine initialization
	state_machine.init(self, animations)
	
	hurtbox_component.hurt.connect(_damaged.bind(1))

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event) # state machine input update

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta) # state machine physics frame update

func _process(delta):
	state_machine.process_frame(delta) # state machine physics frame update

func summon_projectile(proj: Node2D, pos: Vector2) -> void:
	get_tree().root.add_child(proj)
	proj.global_position = pos

func _damaged(hitbox: HitboxComponent) -> void:
	hp = hp - max(0, hitbox.damage - armor)
	
	if hp <= 0:
		queue_free()
