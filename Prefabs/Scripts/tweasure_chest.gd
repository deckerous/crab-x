extends Node2D

@export var loot: Array

signal give_loot(loot: Array)

func _on_area_2d_area_entered(area: Area2D) -> void:
	print_debug(area.name)
	if area.name == "CollectableComponent":
		give_loot.emit(loot)
		queue_free()
