extends Node2D

@onready var curr_state = "Default"

func _ready() -> void:
	get_node(curr_state).run()

func change_state(name: String) -> void:
	# free timer
	for child in get_children():
		if child is Timer:
			child.queue_free()
	
	# update state
	curr_state = name
	get_node(name).run()
