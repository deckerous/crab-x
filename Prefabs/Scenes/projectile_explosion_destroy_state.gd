extends State

@export var explosion_scene: PackedScene

func enter() -> void:
	super()
	var inst : Explosion = explosion_scene.instantiate()
	entity.summon_projectile(inst, entity.global_position)
	animations.hide()
	inst.explosion_finished.connect(func(): entity.call_deferred("queue_free"))
