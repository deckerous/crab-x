class_name Level
extends Node2D

@export_group("Level Properties")
@export var next_level: PackedScene
@export var level_complete: bool
@export var starting_crab_count: int = 1

enum WEAPONS {EMPTY, SLINGSHOT, GLOCK, RPG} 
@export var starting_weapon = WEAPONS.EMPTY

@onready var graphics = $Graphics
@onready var enemies = $Enemies
@onready var player = $Player

func _ready() -> void:
	player.add_crabs(starting_crab_count)
