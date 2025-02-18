extends State

@export_group("Transition States")
@export var telegraph_attack: State

func process_physics(delta: float) -> State:
	if entity.targetting_component.targeted_crab:
		return telegraph_attack
	
	return null
