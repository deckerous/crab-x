class_name HitboxComponent
extends Area2D

@export var damage : float

@onready var collision_shape_2d

signal hit_hurtbox(hurtbox)

func _ready() -> void:
	if get_children().size() > 0:
		collision_shape_2d = get_child(0)
	area_entered.connect(_on_area_entered)

func _on_area_entered(hurtbox: HurtboxComponent) -> void:
	# Make sure the area we are overlapping is a hurtbox
	if not hurtbox is HurtboxComponent: return
	if !hurtbox.vulnerable: return
	
	hit_hurtbox.emit(hurtbox)
	hurtbox.hurt.emit(self)
