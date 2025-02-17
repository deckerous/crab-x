extends Node2D

@onready var area_2d = $Area2D
@onready var delete_timer = $DeleteTimer

func _ready() -> void:
	area_2d.area_entered.connect(_delete)
	delete_timer.timeout.connect(func(): call_deferred("queue_free"))

func _delete(area: Area2D) -> void:
	queue_free()
