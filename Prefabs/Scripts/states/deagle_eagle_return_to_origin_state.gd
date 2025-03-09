extends State

@export_group("Transition States")
@export var idle: State

@export var return_speed: float = 300

@onready var origin_area = $OriginArea
@onready var null_timer = $NullTimer

func _ready() -> void:
	origin_area.body_entered.connect(_eagle_returned)
	null_timer.timeout.connect(_detect_no_player)
	
	await get_tree().create_timer(0.2).timeout
	origin_area.global_position = entity.global_position

func _eagle_returned(body: Node2D) -> void:
	if body.name == "DeagleEagleEntity" and entity.state_machine.current_state.name == "ReturnToOrigin":
		entity.state_machine.change_state_str("Shoot")

func process_physics(delta: float) -> State:
	super(delta)
	
	entity.move_and_slide()
	
	if entity.targetting_component.targeted_crab != null:
		var dir_to_origin_area = entity.global_position.direction_to(origin_area.global_position)
		entity.velocity = dir_to_origin_area * return_speed
	else:
		null_timer.start()
	
	return null

func _detect_no_player() -> void:
	if entity.targetting_component.targeted_crab == null:
		entity.state_machine.change_state_str("Idle")
