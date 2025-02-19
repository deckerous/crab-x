class_name Level
extends Node2D

@export_group("Level Properties")
@export var next_level: PackedScene
@export var level_complete: bool
@export var starting_crab_count: int = 1
@export var num_bosses: int = 1

enum WEAPONS {EMPTY, SLINGSHOT, GLOCK, RPG} 
@export var starting_weapon = WEAPONS.EMPTY
@export var level_id: String

@onready var graphics = $Graphics
@onready var enemies = $Enemies
@onready var player = $Player
@onready var dialogue = $DialogueHandler
@onready var transition_player = $Transition/AnimationPlayer

@onready var bosses_killed = 0

func _ready() -> void:
	transition_player.play("fade_out")
	player.add_crabs(starting_crab_count)
	if starting_weapon != WEAPONS.EMPTY:
		player.change_weapon(starting_weapon)
	dialogue.trigger_visible()
	
func next_level_func() -> void:
	if next_level != null:
		var next_level_instance = next_level.instantiate()
		print_debug(next_level_instance.level_id)
		if !PlayerVariable.debug:
			Analytics.add_event("Player moved to " + next_level_instance.level_id)
		transition_player.play("fade_in")
		get_tree().change_scene_to_packed(next_level)

func level_complete_func() -> void:
	if !PlayerVariable.debug:
		Analytics.add_event("Player beat " + level_id)
	level_complete = true
	player.get_child(0)._on_level_complete()
	
func boss_killed(unused) -> void:
	bosses_killed += 1
	if bosses_killed == num_bosses:
		level_complete_func()
