extends Node2D

@onready var points = $Points

func _ready() -> void:
	
	for point in points.get_children():
		point.emitting = true
		
		await get_tree().create_timer(0.05).timeout
