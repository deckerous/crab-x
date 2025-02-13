extends Button

func _on_button_down() -> void:
	visible = false
	$"../DialogueHandler".trigger_visible()
