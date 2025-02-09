class_name State
extends Node2D

## Base State class that acts as an interface for new states to be built from

@export var animation_name: String

var animations: AnimatedSprite2D
var entity: CharacterBody2D

# Called when the state is entered to intialize fields and behavior
func enter() -> void:
	animations.play(animation_name)

# Called when the state is exited and wrap up behavior is activated
func exit() -> void:
	pass

# Process player inputs that return a new state for the state machine to enter
func process_input(event: InputEvent) -> State:
	return null

# Process frame data and return new state for state machine to enter
func process_frame(delta: float) -> State:
	return null

# Process physics frame data and return new state for the state machine to enter
func process_physics(delta: float) -> State:
	return null
