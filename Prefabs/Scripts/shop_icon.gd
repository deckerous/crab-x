extends Node2D

@export var player: Node2D

@onready var collision_box = $EnterCollision/CollisionShape2D
@onready var timer = $Timer
@onready var hovered = 0
@onready var interactable = true

signal enter_shop(sheckles)

func _ready() -> void:
	pass

func _on_area_2d_area_entered(area: Area2D) -> void:
	# print_debug(area.name)
	PlayerVariable.in_shop = true
	print("Shop_icon.gd, in_shop = ", PlayerVariable.in_shop)
	if area.name == "CollectableComponent" and interactable:
		if hovered == 0:
			enter_shop.emit(player.coin_count)
		hovered = hovered + 1

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.name == "CollectableComponent":
		hovered = hovered - 1


func _on_shop_exit(unused) -> void:
	interactable = false
	timer.start(2)

func _on_timer_timeout() -> void:
	interactable = true
