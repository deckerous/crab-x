class_name EnemyWanderState
extends State

@export_group("Transition States")
@export var aggro: State

@export_group("Wander Properties")
@export var wander_speed: float = 15.0
@export var wander_time_min: float = 1.0
@export var wander_time_max: float = 3.0

@onready var wander_timer = $WanderTimer
@onready var wait_timer = $WaitTimer

var origin = Vector2.ZERO
var at_origin = true

var patrol_direction = Vector2.ZERO
var patrolling = false

var is_waiting = false

func _ready() -> void:
	wander_timer.timeout.connect(func(): 
		patrolling = false
		is_waiting = true
		wait_timer.start()
	)
	wait_timer.timeout.connect(func(): is_waiting = false)

func enter() -> void:
	super()
	at_origin = true
	patrolling = false
	is_waiting = false
	origin = entity.global_position

func process_physics(delta: float) -> State:
	_wander()
	
	if entity.targetting_component.targeted_crab:
		return aggro
	
	return null

func _wander() -> void:
	if at_origin and !is_waiting:
		patrol_direction = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
		wander_timer.start(randf_range(wander_time_min, wander_time_max))
		patrolling = true
		at_origin = false
	
	if patrolling:
		entity.velocity = patrol_direction * wander_speed
		entity.move_and_slide()
	
	if is_waiting:
		entity.velocity = Vector2.ZERO
		entity.move_and_slide()
	
	if !at_origin and !patrolling and !is_waiting:
		entity.velocity = -patrol_direction * wander_speed
		entity.move_and_slide()
		
		if entity.global_position.is_equal_approx(origin):
			at_origin = true
			is_waiting = true
			wait_timer.start()
