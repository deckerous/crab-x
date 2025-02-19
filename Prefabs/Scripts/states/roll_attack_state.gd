class_name EnemyRollState
extends State

@export_group("Transition States")
@export var telegraphed_attack: State

@export_group("Roll Properties")
@export var roll_speed: float = 65.0
@export var rolling_time_min: float = 3.0
@export var rolling_time_max: float = 4.0
@export var num_attacks_min: int = 3
@export var num_attacks_max: int = 5

@onready var roll_timer = $RollTimer

var origin = Vector2.ZERO
var at_origin = true

var roll_direction = Vector2.ZERO
var rolling = false

var roll_counter = randi_range(num_attacks_min, num_attacks_max)

func _ready() -> void:
	roll_timer.timeout.connect(func(): rolling = false)

func enter() -> void:
	super()
	at_origin = true
	rolling = false
	origin = entity.global_position
	roll_counter = randi_range(num_attacks_min, num_attacks_max)

func process_physics(delta: float) -> State:
	if roll_counter == 0 and at_origin:
		return telegraphed_attack
	
	_roll()
	
	return null

func _roll() -> void:
	if at_origin:
		var rough_dir = Vector2(entity.targetting_component.targeted_crab.global_position.x + randf_range(-0.2, 0.2), entity.targetting_component.targeted_crab.global_position.y)
		roll_direction = entity.global_position.direction_to(rough_dir).normalized()
		roll_timer.start(randf_range(rolling_time_min, rolling_time_max))
		rolling = true
		at_origin = false
	
	if rolling:
		entity.velocity = roll_direction * roll_speed
		entity.move_and_slide()
	
	if !at_origin and !rolling:
		entity.velocity = -roll_direction * roll_speed
		entity.move_and_slide()
		
		if entity.global_position.y < origin.y:
			at_origin = true
			roll_counter -= 1
