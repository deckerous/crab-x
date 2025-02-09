extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var current_velocity: Vector2 = Vector2(0, 0)

func _physics_process(delta: float) -> void:
	velocity = current_velocity
	move_and_collide(velocity)

func _on_entity_change_velocity(vel: Variant) -> void:
	current_velocity = vel
