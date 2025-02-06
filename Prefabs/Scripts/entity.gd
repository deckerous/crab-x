class_name EntityBase

extends Node2D

@export var hp: int = 10
@export var armor: int = 0
@export var damage: int = 0
@export var vulnerable: bool = true

@onready var collision = $CharacterBody2D/CollisionBox

var current_velocity: Vector2

signal change_velocity(velocity)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_meta("CreatedEntity", true)
	collision.set_meta("damage", damage)
	current_velocity = Vector2(0, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	change_velocity.emit(current_velocity)
	
func summon_projectile(proj: Node2D, pos: Vector2) -> void:
	add_child(proj)
	proj.position = position + pos
	
func set_velocity(vel: Vector2) -> void:
	current_velocity = vel

func _hit_by_projectile(proj: CollisionObject2D) -> void:
	if !vulnerable:
		return
	
	var damage = proj.get_meta("damage")
	hp = hp - max(0, damage - armor)
