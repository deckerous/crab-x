class_name CrabEntity
extends Entity

@export var is_rally: bool = false

@onready var navigation_agent_2d = $NavigationAgent2D

func _physics_process(delta) -> void:
	super(delta)
	# rotate crab to point at the cursor
	global_rotation = global_position.direction_to(get_global_mouse_position()).angle() + PI/2.0

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	if !is_rally:
		velocity = safe_velocity

func external_state_change(state) -> void:
	state_machine.change_state_str(state)
