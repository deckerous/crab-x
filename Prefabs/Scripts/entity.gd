class_name EntityBase
extends Node2D

@export var hp: int = 10
@export var armor: int = 0

@onready var collision = $CharacterBody2D/CollisionBox
@onready var hitbox_component = $CharacterBody2D/HitboxComponent
@onready var hurtbox_component = $CharacterBody2D/HurtboxComponent

var current_velocity: Vector2

signal change_velocity(velocity)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox_component.hurt.connect(_damaged.bind(1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	change_velocity.emit(current_velocity)
	
func summon_projectile(proj: Node2D, pos: Vector2) -> void:
	add_child(proj)
	proj.position = position + pos
	
func set_velocity(vel: Vector2) -> void:
	current_velocity = vel

func _damaged(hitbox: HitboxComponent) -> void:
	hp = hp - max(0, hitbox.damage - armor)
	
	if hp <= 0:
		queue_free()
