extends Node2D

@onready var next_arrow = $"CanvasLayer/Dialogue Box/NextArrow"
@onready var text_box = $"CanvasLayer/Dialogue Box/RichTextLabel"
@onready var collision_shape = $"CanvasLayer/Area2D/CollisionShape2D"
@onready var canvas = $CanvasLayer

signal tutorial_closed()

var interactable = false
var curr_index = 0
@export var text_array = ['Welcome to your first day in the Crustacean Army, [shake rate=25level=10]prawn[/shake]! I am General Crusty Shawn, and I will be your drillmaster today! First things first, you must learn the pecking order!',
						  'First comes you, then the sand, then the humans, then crabs, then our president, and then [shake rate=25level=10]ME![/shake] So listen to everything I say and you [i]might[/i] make it out alive.',
						  'Lesson number one, [shake rate=25level=10]prawn[/shake]! Use the WASD keys to move! Now, move it!']

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text_box.text = text_array[0]
	text_box.visible_characters = 0
	next_arrow.visible = false
	canvas.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if canvas.visible and !interactable:
		text_box.visible_ratio += 0.01
		if text_box.visible_ratio >= 1:
			interactable = true
			next_arrow.visible = true
			collision_shape.disabled = false

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action("shoot"):
		interactable = false
		next_arrow.visible = false
		collision_shape.disabled = true
		curr_index += 1
		text_box.visible_ratio = 0
		if curr_index >= text_array.size():
			canvas.visible = false
			tutorial_closed.emit()
			get_tree().paused = false
			return
		else:
			text_box.text = text_array[curr_index]

func trigger_visible() -> void:
	get_tree().paused = true
	PhysicsServer2D.set_active(true)
	canvas.visible = true

func tutorial_time(array) -> void:
	text_array = array
	curr_index = 0
	text_box.text = text_array[0]
	get_tree().paused = true
	PhysicsServer2D.set_active(true)
	canvas.visible = true
