extends Entity

@onready var targetting_component = $TargettingComponent

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
