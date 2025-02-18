extends CanvasLayer

class_name ui

# TODO: Connect to actual values
var total_coins = 0
var crabs = 0  
var equipped_item = "Empty"
var equipped_weapon = "Empty"
var game_score = 0
var is_paused = false # Keep track of pause state

@onready var during_game_screen = $during_game_screen
@onready var end_of_game_screen = $end_of_game_screen
@onready var pause_menu_screen = $pause_menu
@onready var pause_background = $pause_menu/pause_screen_background

# Get references to individual labels
@onready var crabs_label = $during_game_screen/crabs_label
@onready var coins_label = $during_game_screen/coins_label
@onready var item_label = $during_game_screen/item_label
@onready var weapon_label = $during_game_screen/weapon_label


func _ready() -> void:
	update_during_game_ui() # Initialize the UI

func update_crabs(count: int):
	crabs = count
	update_during_game_ui()

func update_coins(coins: int):
	total_coins = coins
	update_during_game_ui()

func update_item(item: String):
	equipped_item = item
	update_during_game_ui()

func update_weapon(weapon: String):
	equipped_weapon = weapon
	update_during_game_ui()

func update_during_game_ui():
	crabs_label.text = "%d" % crabs
	coins_label.text = "%d" % total_coins
	item_label.text = equipped_item
	weapon_label.text = equipped_weapon

func _on_game_over():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	during_game_screen.visible = false
	end_of_game_screen.visible = true
	$end_of_game_screen/end_of_game_score_display/score_label.text = "%d" % game_score
	# TODO: Implement way to quit	

func _on_resume_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	toggle_pause_menu() 

func _on_restart_button_pressed():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	get_tree().reload_current_scene()  # Restart the game

func _on_quit_button_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
	# TODO: Save progress as you leave?

func toggle_pause_menu():
	is_paused = not is_paused
	get_tree().paused = not get_tree().paused
	during_game_screen.visible = not during_game_screen.visible
	pause_menu_screen.visible = get_tree().paused
	pause_background.visible = get_tree().paused
	

func _on_settings_button_pressed():
	pass
	# TODO: Implement the settings we want
