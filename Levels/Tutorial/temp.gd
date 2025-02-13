extends Button

func _on_button_down() -> void:
	get_tree().paused = true
	PhysicsServer2D.set_active(true)
	visible = false
	$"../DialogueHandler".trigger_visible()
