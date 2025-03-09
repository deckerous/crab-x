extends State

@export_group("Transition States")
@export var shoot: State

func process_physics(delta: float) -> State:
	if entity.targetting_component.targeted_crab:
		return shoot
	
	return null
