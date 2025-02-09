extends State

func enter() -> void:
	super()
	entity.call_deferred("queue_free")
