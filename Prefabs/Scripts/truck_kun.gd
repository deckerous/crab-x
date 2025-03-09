extends Node2D

@export_group("Truck-Kun Properties")
@export var speed : float = 0.005

@onready var path_follow_2d = $Path2D/PathFollow2D

func _physics_process(delta):
	path_follow_2d.progress_ratio += speed
