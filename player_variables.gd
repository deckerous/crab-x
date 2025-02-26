extends Node

@onready var num_coins = 0

var debug = true
var in_shop = false
var num_crabs = 0
var cur_weapon = "none"
var cur_level = 0

# TODO P1
var cur_item = "none"
var time_played = 0
var score = 0

#### Save System Below ####

var level_complete = false
var SAVE_PATH = "user://save_file.cfg"
var TEST_SAVE_PATH = "res://save_file.cfg"
var PATH = ""
var config = ConfigFile.new()
var load_response = config.load(SAVE_PATH)
var test_load_response = config.load(TEST_SAVE_PATH)

# Dictionary of current levels and their path
var level = {
	"main": "res://UI/start_menu.tscn",
	0: "res://Levels/Tutorial/tutorial_refactor.tscn",
	1: "res://Levels/Beach/beach1.tscn",
	2: "res://Levels/Beach/beach2.tscn",
	3: "res://Levels/Beach/beach3.tscn",
}

# Debug settings switcher. Add more here...
func _ready() -> void:
	if debug == true:
		PATH = TEST_SAVE_PATH
	else:
		PATH = SAVE_PATH

# Save/Load Functions
func save_values(section, key):
	config.set_value(section, key, cur_level)
	config.save(PATH)

func load_values(section, key):
	cur_level = config.get_value(section, key, cur_level)
