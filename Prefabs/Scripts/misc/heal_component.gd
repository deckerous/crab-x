class_name HealComponent
extends Area2D

@export var heal_amt = 10

func _ready() -> void:
	body_entered.connect(_heal)

func _heal(body: Node2D) -> void:
	if body is CrabEntity:
		if body.hp < body.max_hp:
			get_parent().call_deferred("queue_free")
