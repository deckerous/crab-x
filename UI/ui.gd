extends CanvasLayer

class_name ui

# TODO: Connect to actual values
var game_score = 0
var is_paused = false # Keep track of pause state

@onready var during_game_screen = $during_game_screen
@onready var end_of_game_screen = $end_of_game_screen
@onready var end_of_level_screen = $winning
@onready var pause_menu_screen = $pause_menu
@onready var pause_background = $pause_menu/pause_screen_background

@onready var crabs_label = $during_game_screen/crabs_label
@onready var coins_label = $during_game_screen/coins_label
@onready var item_label = $during_game_screen/item_label
@onready var weapon_label = $during_game_screen/weapon_label

signal next_level

func _ready() -> void:
	update_during_game_ui() 

func _process(delta):
	update_during_game_ui()

func update_during_game_ui():
	crabs_label.text = "%d" % PlayerVariable.num_crabs
	coins_label.text = "%d" % PlayerVariable.num_coins
	item_label.text = PlayerVariable.cur_item
	weapon_label.text = PlayerVariable.cur_weapon

func _on_game_over():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	during_game_screen.visible = false
	end_of_game_screen.visible = true
	$end_of_game_screen/end_of_game_score_display/score_label.text = "%d" % game_score
	# TODO: Implement way to quit	

func _on_level_complete():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	get_tree().paused = true
	during_game_screen.visible = false
	end_of_level_screen.visible = true

func _on_resume_button_pressed():
	toggle_pause_menu() 
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

func _on_restart_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	CrabLogs.log_stage_restart()
	get_tree().paused = false
	get_tree().reload_current_scene()  # Restart the game

func _on_quit_button_pressed():
	get_tree().paused = false
	PlayerVariable.save_values("Levels", "Current Level")  # SAVE ON QUIT
	get_tree().change_scene_to_file("res://UI/start_menu.tscn")
	# if !PlayerVariable.debug:
	#	 await Analytics.handle_exit()
	await CrabLogs.log_player_quit(false)
	# TODO: Save progress as you leave?

func _on_next_level_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	get_tree().paused = false
	next_level.emit()

func toggle_pause_menu():
	if not PlayerVariable.in_shop:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		get_tree().paused = not get_tree().paused
		pause_menu_screen.visible = get_tree().paused
		#pause_background.visible = get_tree().paused
		# during_game_screen.visible = not during_game_screen.visible

	

func _on_settings_button_pressed():
	pass
	# TODO: Implement the settings we want
