extends CanvasLayer

class_name ui
signal game_started

var total_coins = 0
var crabs = 0  
var equipped_item = "Empty"
var equipped_weapon = "Sling Shot"
var game_score = 0

@onready var during_game_screen = $during_game_screen
@onready var end_of_game_screen = $end_of_game_screen
@onready var pause_menu_screen = $pause_menu_screen

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

func update_item(item: String): # Type hint for item
	equipped_item = item
	update_during_game_ui()

func update_weapon(weapon: String): # Type hint for weapon
	equipped_weapon = weapon
	update_during_game_ui()

func update_during_game_ui():
	crabs_label.text = "%d" % crabs
	coins_label.text = "%d" % total_coins
	item_label.text = equipped_item # No need for formatting here
	weapon_label.text = equipped_weapon # No need for formatting here

func _on_game_over():
	during_game_screen.visible = false
	end_of_game_screen.visible = true
	$end_of_game_screen/end_of_game_score_display/score_output.text = "%d" % game_score

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
