extends State

# States to transition to
@export_group("Transition states")
@export var slingshot: State
@export var glock: State
@export var rpg: State
@export var sniper: State

## Override: Process player inputs that return a new state for the state machine to enter
#func process_input(event: InputEvent) -> State:
	#if Input.is_action_just_pressed("slingshot"):
		#return slingshot
	#if Input.is_action_just_pressed("glock"):
		#return glock
	#if Input.is_action_just_pressed("rpg"):
		#return rpg
	#if Input.is_action_just_pressed("sniper"):
		#return sniper
	#
	#return null
