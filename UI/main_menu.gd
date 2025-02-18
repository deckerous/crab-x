extends CanvasLayer




func _ready():
	pass

func _on_new_game_button_pressed():
	print("New game button pressed")
	get_tree().change_scene_to_file("res://Levels/Tutorial/tutorial.tscn") # TODO: replace with actual game scene

func _on_continue_button_pressed():
	print("Continue button pressed")
	# TODO: implement save system
	pass

func _on_settings_button_pressed():
	print("Settings button pressed")
	# TODO: implement settings screen
	pass

func _on_quit_button_pressed():
	print("Game was quit")
	get_tree().quit()
