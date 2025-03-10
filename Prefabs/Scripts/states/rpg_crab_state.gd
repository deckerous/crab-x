extends GunState

# States to transition to
@export_group("Transition states")
@export var glock: State
@export var empty: State
@export var slingshot: State
@export var sniper: State

# Override: Process player inputs that return a new state for the state machine to enter
func process_input(event: InputEvent) -> State:
	super(event)
	
	if Input.is_action_just_pressed("empty"):
		return empty
	if Input.is_action_just_pressed("slingshot"):
		return slingshot
	if Input.is_action_just_pressed("glock"):
		return glock
	if Input.is_action_just_pressed("sniper"):
		return sniper
	
	return null

func process_physics(delta: float) -> State:
	super(delta)
	
	if projectile_fired:
		AudioManager.play_sfx("rpg")
		projectile_fired = false
	
	return null
