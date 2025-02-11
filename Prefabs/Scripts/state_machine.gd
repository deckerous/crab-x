extends Node2D

## Handles state transitions and state processing for inputs, frames, and physics frames

@export var starting_state: State

var current_state: State

signal state_changed

# Initialize the state machine by giving each child state a reference to the
# entity object it belongs to and enter the default starting_state.
func init(entity: CharacterBody2D, animations: AnimatedSprite2D) -> void:
	for child in get_children():
		child.entity = entity
		child.animations = animations
	
	# Initialize to the default state
	change_state(starting_state)

# Change to the new state by first calling any exit logic on the current state.
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()
	state_changed.emit()

func change_state_str(new_state: String) -> void:
	var state_wanted: State
	for child in get_children():
		if child.name == new_state:
			state_wanted = child
	
	if current_state:
		current_state.exit()
	
	current_state = state_wanted
	current_state.enter()
	state_changed.emit()

# Pass through functions for the Entity to call,
# handling state changes as needed.
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
