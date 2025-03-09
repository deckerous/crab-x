extends Node

const FLASH_MATERIAL = preload("res://Shaders/white_flash_shader.tres")

@export var sprite: CanvasItem
@export var flash_duration: = 0.2

var original_sprite_material: Material

@onready var flash_timer = $FlashTimer

func _ready() -> void:
	original_sprite_material = sprite.material

func flash():
	sprite.material = FLASH_MATERIAL
	flash_timer.start(flash_duration)
	await flash_timer.timeout
	sprite.material = original_sprite_material
