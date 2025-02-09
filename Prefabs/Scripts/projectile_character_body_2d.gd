extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var current_velocity: Vector2 = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	velocity = current_velocity
	var collision_info = move_and_collide(velocity)
	if collision_info:
		var collider = collision_info.get_collider()
		if collider is TileMapLayer:
			queue_free()

func _on_entity_change_velocity(vel: Variant) -> void:
	current_velocity = vel
