extends Node2D

@export var curr_state : String
@export var run_on_spawn : bool

func _ready() -> void:
	if run_on_spawn:
		get_node(curr_state).run()

func change_state(name: String) -> void:
	# free timer
	for child in get_children():
		if child is Timer:
			child.queue_free()
	
	# update state
	curr_state = name
	get_node(name).run()
