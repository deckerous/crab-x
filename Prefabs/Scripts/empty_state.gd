extends BaseState

func _process(delta):
	if state_machine.curr_state == self.name:
		if Input.is_action_just_pressed("slingshot") and self.name != "Slingshot":
			state_machine.change_state("Slingshot")
		elif Input.is_action_just_pressed("glock") and self.name != "Glock":
			state_machine.change_state("Glock")
		elif Input.is_action_just_pressed("rpg") and self.name != "RPG":
			state_machine.change_state("RPG")
