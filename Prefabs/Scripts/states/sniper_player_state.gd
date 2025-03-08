extends GunState

# States to transition to
@export_group("Transition states")
@export var glock: State
@export var empty: State
@export var slingshot: State
@export var rpg: State

@onready var sniper_particles = $SniperParticles

# Override: Process player inputs that return a new state for the state machine to enter
func process_input(event: InputEvent) -> State:
	super(event)
	
	if Input.is_action_just_pressed("empty"):
		return empty
	if Input.is_action_just_pressed("slingshot"):
		return slingshot
	if Input.is_action_just_pressed("glock"):
		return glock
	if Input.is_action_just_pressed("rpg"):
		return rpg
	
	return null

func process_physics(delta: float) -> State:
	super(delta)
	
	if projectile_fired:
		sniper_particles.restart()
		projectile_fired = false
	
	return null
