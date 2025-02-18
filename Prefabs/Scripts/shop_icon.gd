extends Node2D

@export var player: Node2D

@onready var collision_box = $EnterCollision/CollisionShape2D
@onready var hovered = 0

signal enter_shop(sheckles)

func _ready() -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	print_debug(area.name)
	if area.name == "CollectableComponent":
		if hovered == 0:
			enter_shop.emit(player.coin_count)
		hovered = hovered + 1

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "CollectableComponent":
		hovered = hovered - 1
