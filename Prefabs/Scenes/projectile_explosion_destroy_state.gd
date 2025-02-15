extends DestroyState

@onready var explosion = $Explosion

func enter() -> void:
	explosion.start_explosion()
	animations.hide()
	await explosion.explosion_finished
	super()
