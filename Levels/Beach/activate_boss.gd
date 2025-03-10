extends Node2D

@export var activatable: Node2D

func _on_area_entered(area: Area2D) -> void:
	if area.name == "CollectableComponent":
		AudioManager.play_bgm("beachBoss")
		activatable.process_mode = Node.PROCESS_MODE_INHERIT
		queue_free()
