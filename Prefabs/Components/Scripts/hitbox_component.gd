class_name HitboxComponent
extends Area2D

@export var damage : float

signal hit_hurtbox(hurtbox)

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(hurtbox: HurtboxComponent) -> void:
	# Make sure the area we are overlapping is a hurtbox
	if not hurtbox is HurtboxComponent: return
	if !hurtbox.vulnerable: return
	
	hit_hurtbox.emit(hurtbox)
	hurtbox.hurt.emit(self)
