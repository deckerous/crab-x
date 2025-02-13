extends Node2D

@onready var area_2d = $Area2D

func _ready() -> void:
	area_2d.area_entered.connect(_delete)

func _delete(area: Area2D) -> void:
	queue_free()
