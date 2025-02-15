class_name Explosion
extends Node2D

@onready var cpu_particles_2d = $CPUParticles2D
@onready var collision_shape_2d = $HitboxComponent/CollisionShape2D

signal explosion_finished

func _ready() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	cpu_particles_2d.finished.connect(_finished_explosion)

func _finished_explosion() -> void:
	explosion_finished.emit()
	call_deferred("queue_free")

# Call when rocket hits something
func start_explosion():
	cpu_particles_2d.emitting = true
	collision_shape_2d.set_deferred("disabled", false)
