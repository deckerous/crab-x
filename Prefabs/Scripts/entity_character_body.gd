extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var current_velocity: Vector2 = Vector2(0, 0)

signal hit_by_projectile(projectile)

func _physics_process(delta: float) -> void:
	velocity = current_velocity
	var collision_info = move_and_collide(velocity)
	if collision_info:
		if collision_info.get_local_shape().get_meta("CreatedEntity") == true:
			hit_by_projectile.emit(collision_info.get_local_shape())

func _on_entity_change_velocity(velocity: Variant) -> void:
	current_velocity = velocity
