extends "res://Prefabs/Scripts/entity_character_body.gd"

@onready var navigation_agent_2d = $NavigationAgent2D

func _physics_process(delta: float) -> void:
	super(delta)
	global_rotation = global_position.direction_to(get_global_mouse_position()).angle() + PI/2.0

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
