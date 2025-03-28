extends Node2D

@export var player: Player

@onready var collision_box = $EnterCollision/CollisionShape2D

signal enter_shop(sheckles)

func _ready() -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent() == player.rally_point_crab_entity:
		enter_shop.emit(player.coin_count)
