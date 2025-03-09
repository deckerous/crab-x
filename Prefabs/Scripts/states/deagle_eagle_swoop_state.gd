extends State

@export_group("Transition States")
@export var idle: State
@export var return_to_origin: State

@export_group("Phase Properties")
@export var swoop_speed: float = 220
@export var min_swoops: int = 5
@export var max_swoops: int = 7

@export var entity_id: String = "DeagleEagleSwoop"

@onready var talon_particles = $TalonParticles
@onready var talon_particles_2 = $TalonParticles2
@onready var collision_shape_2d = $HitboxComponent/CollisionShape2D
@onready var cooldown_timer = $CooldownTimer
@onready var null_timer = $NullTimer

@onready var num_swoops_before_shoot = 0
@onready var num_swoops = 0

var cooldown = false

func _ready() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	cooldown_timer.timeout.connect(func(): 
		cooldown = false
	)
	null_timer.timeout.connect(_detect_no_player)
	talon_particles.visible = false
	talon_particles_2.visible = false

func enter() -> void:
	super()
	collision_shape_2d.set_deferred("disabled", false)
	talon_particles.visible = true
	talon_particles_2.visible = true
	num_swoops_before_shoot = randi_range(min_swoops, max_swoops)
	num_swoops = 0

func exit() -> void:
	collision_shape_2d.set_deferred("disabled", true)
	talon_particles.visible = false
	talon_particles_2.visible = false

func process_physics(delta: float) -> State:
	super(delta)
	
	entity.move_and_slide()
	
	if entity.targetting_component.targeted_crab != null:
		if num_swoops >= num_swoops_before_shoot:
			return return_to_origin
		elif !cooldown:
			var fly_direction = entity.global_position.direction_to(entity.targetting_component.targeted_crab.global_position) + 0.1 * entity.targetting_component.targeted_crab.velocity.normalized()
			entity.velocity = fly_direction * swoop_speed
			
			num_swoops += 1
			cooldown = true
			cooldown_timer.start()
	else:
		null_timer.start()
	
	return null

func _detect_no_player() -> void:
	if entity.targetting_component.targeted_crab == null:
		entity.state_machine.change_state_str("Idle")
