class_name Level
extends Node2D

@export_group("Level Properties")
@export var next_level: PackedScene
@export var level_complete: bool
@export var starting_crab_count: int = 1
@export var num_bosses: int = 1

enum WEAPONS {EMPTY, SLINGSHOT, GLOCK, RPG, SNIPER} 
@export var starting_weapon = WEAPONS.EMPTY
@export var level_id: String

@onready var graphics = $Graphics
@onready var enemies = $Enemies
@onready var player: Player = $Player
#@onready var dialogue = $DialogueHandler
@onready var dialogue = null

@onready var bosses_killed = 0

func _ready() -> void:
	CrabLogs.log_stage_start(level_id)
	player.add_crabs(starting_crab_count)
	if starting_weapon != WEAPONS.EMPTY:
		player.change_weapon(starting_weapon)
	
	dialogue = find_child("DialogueHandler")
	if dialogue:
		dialogue.trigger_visible()
	
	Transition.fade_out()

func next_level_func() -> void:
	if next_level != null:
		var next_level_instance = next_level.instantiate()
		print_debug(next_level_instance.level_id)
		# if !PlayerVariable.debug:
		#	 Analytics.add_event("Player moved to " + next_level_instance.level_id)
		#Transition.fade_in()
		get_tree().change_scene_to_packed(next_level)

func level_complete_func() -> void:
	PlayerVariable.cur_level += 1 # index level up
	# if !PlayerVariable.debug:
	#	 Analytics.add_event("Player beat " + level_id)
	CrabLogs.log_stage_complete(player.cur_weapon, player.crab_count, player.coin_count, player.kill_count)
	PlayerVariable.difficulty_scale += PlayerVariable.DIFFICULTY_SCALE_AMOUNT
	level_complete = true
	player.ui_instance._on_level_complete()
	await get_tree().create_timer(3.5).timeout
	Transition.fade_in()

func boss_killed(unused) -> void:
	bosses_killed += 1
	if bosses_killed == num_bosses:
		level_complete_func()
