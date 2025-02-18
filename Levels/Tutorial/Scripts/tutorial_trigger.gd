extends Node2D

@export var dialogue: Array
@export var wall: TileMapLayer
@export var start_visible = true

@onready var our_general = $Sprite2D
@onready var arrow = $Arrow
@onready var moving_down = true

signal start_tutorial(text)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !start_visible:
		our_general.visible = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "CollectableComponent":
		if wall != null:
			wall.queue_free()
		start_tutorial.emit(dialogue)
		queue_free()

func _physics_process(delta: float) -> void:
	if moving_down:
		arrow.translate(Vector2(0, 15 * delta))
	else:
		arrow.translate(Vector2(0, -15 * delta))
	
	if arrow.position.y < -6 or arrow.position.y > 0:
		moving_down = !moving_down
