extends CanvasLayer


@onready var background = $main_menu_screen_background
@onready var new_game_button = $new_game_button
@onready var continue_button = $continue_button
@onready var settings_button = $settings_button
@onready var quit_button = $quit_button

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
