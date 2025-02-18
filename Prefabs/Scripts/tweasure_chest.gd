extends Node2D

@export var loot: Array

@onready var collision_box = $Area2D/CollisionShape2D
@onready var text_edit = $TextEdit
@onready var sprite = $Sprite2D

@onready var looted = false
@onready var text_pos
@onready var text_pointer = 0
@onready var alpha = 1.0

signal give_loot(loot: Array)

func _ready() -> void:
	text_pos = Vector2(position.x, position.y)

func _on_area_2d_area_entered(area: Area2D) -> void:
	print_debug(area.name)
	if area.name == "CollectableComponent":
		give_loot.emit(loot)
		sprite.hide()
		collision_box.queue_free()
		text_edit.show()
		text_edit.text = "[center]+ " + loot[0]
		looted = true
	
func _physics_process(delta: float) -> void:
	if looted:
		translate(Vector2(0, -0.4))
		alpha -= 0.04
		if alpha <= 0:
			text_pointer += 1
			if text_pointer == loot.size():
				queue_free()
				return
			position = text_pos
			text_edit.text = "[center]+ " + loot[text_pointer]
			alpha = 1.0
		text_edit.modulate = Color(1, 1, 1, alpha)
		
