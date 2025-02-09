class_name HitboxComponent
extends Area2D

@export var damage : float

signal hit_hurtbox(hurtbox)

func _ready() -> void:
	area_entered.connect(_on_area_entered.bind(1))

#TODO: Assign type HurtboxComponent to hurtbox parameter
func _on_area_entered(hurtbox) -> void:
	# TODO: Make sure the area we are overlapping is a hurtbox
	#if not hurtbox is HurtboxComponent: return
	
	if !hurtbox.vulernable: return
	hit_hurtbox.emit(hurtbox)
	
	#hurtbox.hurt.emit(self)
