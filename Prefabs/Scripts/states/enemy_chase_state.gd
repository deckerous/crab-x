class_name EnemyChaseState
extends State

@export_group("Transition states")
@export var wander: State

@export_group("Aggro Properties")
@export var aggro_speed: float = 30.0

func process_physics(delta: float) -> State:
	super(delta)
	
	if entity.targetting_component.targeted_crab != null:
		var nav_agent_node : NavigationAgent2D = entity.targetting_component.navigation_agent_2d
		var curr_position = global_position
		var next_path_position = nav_agent_node.get_next_path_position()
		var new_velocity = curr_position.direction_to(next_path_position).normalized() * aggro_speed
		
		if nav_agent_node.is_navigation_finished():
			new_velocity = lerp(new_velocity, new_velocity, 0.05)
		
		if nav_agent_node.avoidance_enabled:
			
			nav_agent_node.set_velocity(new_velocity)
		else:
			entity._on_navigation_agent_2d_velocity_computed(new_velocity)
		
		if entity.process_mode == Node.PROCESS_MODE_INHERIT:
			entity.move_and_slide()
	else:
		return wander
	
	return null
