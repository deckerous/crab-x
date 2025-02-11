class_name EnemyShootState
extends State

@export_group("Transition states")
@export var wander: State

@export_group("Projectile")
@export var projectile: PackedScene

@onready var cooldown_timer = $CooldownTimer

func enter() -> void:
	super()
	animations.flip_h = true

func exit() -> void:
	animations.flip_h = false
