class_name CrabEntity
extends Entity

@onready var navigation_agent_2d = $NavigationAgent2D
@onready var healing_area_2d = $HealingArea2D
@onready var star = $Star

@onready var is_rally: bool = false : 
	set(value):
		star.visible = value
		
var last_damaged_by: Node2D

signal changed_last_damaged_by(entity: Node2D)

func _ready() -> void:
	super()
	healing_area_2d.area_exited.connect(_heal)

func _physics_process(delta) -> void:
	super(delta)
	# rotate crab to point at the cursor
	global_rotation = global_position.direction_to(get_global_mouse_position()).angle() + PI/2.0

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if !is_rally:
		velocity = safe_velocity

func external_state_change(state) -> void:
	state_machine.change_state_str(state)
	
func _damaged(hitbox: HitboxComponent) -> void:
	last_damaged_by = hitbox.entity_parent
	
	hp = hp - max(0, hitbox.damage - armor)
	_update_health_bar()
	flash_component.flash()
	shake_component.tween_shake()
	
	if hp <= 0:
		self.hide()
		self.process_mode = Node.PROCESS_MODE_DISABLED
		entity_died.emit(name)
		changed_last_damaged_by.emit(last_damaged_by)
		queue_free()

func _heal(area: Area2D) -> void:
	if not area is HealComponent: return
	if !(hp < max_hp): return
	
	hp += area.heal_amt
	_update_health_bar()
