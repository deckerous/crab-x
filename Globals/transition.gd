extends CanvasLayer

@onready var animation_player = $AnimationPlayer

func fade_in() -> void:
	_unhide()
	animation_player.play("fade_in")
	animation_player.get_animation("fade_in")

func fade_out() -> void:
	_unhide()
	animation_player.play("fade_out")

func _hide() -> void:
	self.visible = false

func _unhide() -> void:
	self.visible = true
