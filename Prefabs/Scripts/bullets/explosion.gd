class_name Explosion
extends Node2D

@export var explosion_lifetime_factor: float = 4.5

@onready var cpu_particles_2d = $CPUParticles2D
@onready var collision_shape_2d = $HitboxComponent/CollisionShape2D
@onready var collision_timer = $CollisionTimer

signal explosion_finished

func _ready() -> void:
	#collision_shape_2d.set_deferred("disabled", true)
	cpu_particles_2d.finished.connect(_finished_explosion)
	collision_timer.timeout.connect(func(): collision_shape_2d.queue_free())
	start_explosion()

func _finished_explosion() -> void:
	explosion_finished.emit()
	call_deferred("queue_free")

# Call when rocket hits something
func start_explosion():
	cpu_particles_2d.emitting = true
	var time = cpu_particles_2d.lifetime / explosion_lifetime_factor
	#collision_shape_2d.set_deferred("disabled", false)
	#collision_shape_2d.disabled = false
	collision_timer.start(time)
