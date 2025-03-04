extends Node2D

@export var level_id: String

@onready var transition = $Transition/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Transition.fade_out()
