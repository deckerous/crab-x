extends Node

#var config = ConfigFile.new()
#config.set_value(cur_level)
#config.save("user://save.cfg")

@onready var num_coins = 0

var debug = true
var in_shop = false
var num_crabs = 0
var cur_weapon = "none"
var cur_level = 0

# TODO P0
## Dictionary of current levels and their path
var level = {
	"main": "res://UI/start_menu.tscn",
	0: "res://Levels/Tutorial/tutorial_refactor.tscn",
	1: "res://Levels/Beach/beach1.tscn",
	2: "res://Levels/Beach/beach2.tscn",
	3: "res://Levels/Beach/beach3.tscn",
}

# TODO P1
var cur_item = "none"
var time_played = 0
var score = 0
