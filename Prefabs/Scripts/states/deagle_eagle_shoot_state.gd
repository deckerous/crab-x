extends State

@export_group("Transition States")
@export var idle: State
@export var swoop: State

@export_group("Projectile")
@export var projectile: PackedScene

@export_group("Phase Properties")
@export var min_shoots: int = 4
@export var max_shoots: int = 6

@onready var num_shots_before_swoop = 0
@onready var num_shots = 0

@onready var projectile_spawn_position = $ProjectileSpawnPosition
@onready var projectile_spawn_position_2 = $ProjectileSpawnPosition2
@onready var deagle_particles = $DeagleParticles
@onready var deagle_particles_2 = $DeagleParticles2
@onready var cooldown_timer = $CooldownTimer
@onready var shoot_timer_1 = $ShootTimer1
@onready var shoot_timer_2 = $ShootTimer2
@onready var shoot_timer_3 = $ShootTimer3
@onready var shoot_timer_4 = $ShootTimer4
@onready var null_timer = $NullTimer

var cooldown = false

var pos = 0
var going_forward = true

func _ready() -> void:
	cooldown_timer.timeout.connect(func(): 
		cooldown = false
	)
	shoot_timer_1.timeout.connect(_shoot_gun1)
	shoot_timer_2.timeout.connect(_shoot_gun2)
	shoot_timer_3.timeout.connect(_shoot_gun1)
	shoot_timer_4.timeout.connect(_shoot_gun2)
	null_timer.timeout.connect(_detect_no_player)

func enter() -> void:
	super()
	pos = 0
	num_shots_before_swoop = randi_range(min_shoots, max_shoots)
	num_shots = 0

func process_physics(delta: float) -> State:
	super(delta)
	
	if pos < -TAU:
		going_forward = true
	if pos > TAU:
		going_forward = false
	
	if going_forward:
		pos += delta * 0.5 
	else:
		pos -= delta * 0.5
	
	entity.position.x = entity.position.x + sin(pos)
	entity.position.y = entity.position.y - cos(pos)
	
	if entity.targetting_component.targeted_crab != null:
		if num_shots >= num_shots_before_swoop and shoot_timer_1.is_stopped() and shoot_timer_2.is_stopped() and shoot_timer_3.is_stopped() and shoot_timer_4.is_stopped():
			return swoop
		elif !cooldown:
			shoot_timer_1.start()
			shoot_timer_2.start()
			shoot_timer_3.start()
			shoot_timer_4.start()
			
			num_shots += 1
			cooldown = true
			cooldown_timer.start()
	else:
		null_timer.start()
	
	return null

func _shoot_gun1() -> void:
	if entity.targetting_component.targeted_crab != null:
		var inst1 = projectile.instantiate()
		inst1.global_rotation = projectile_spawn_position.global_position.direction_to(entity.targetting_component.targeted_crab.global_position).angle() + PI/2.0
		inst1.init_projectile(projectile_spawn_position.global_position.direction_to(entity.targetting_component.targeted_crab.global_position))
		entity.summon_projectile(inst1, projectile_spawn_position.global_position)
		deagle_particles.restart()
		inst1.origin = projectile_spawn_position.global_position

func _shoot_gun2() -> void:
	if entity.targetting_component.targeted_crab != null:
		var inst2 = projectile.instantiate()
		inst2.global_rotation = projectile_spawn_position.global_position.direction_to(entity.targetting_component.targeted_crab.global_position).angle() + PI/2.0
		inst2.init_projectile(projectile_spawn_position.global_position.direction_to(entity.targetting_component.targeted_crab.global_position))
		entity.summon_projectile(inst2, projectile_spawn_position_2.global_position)
		deagle_particles_2.restart()
		inst2.origin = projectile_spawn_position_2.global_position

func _detect_no_player() -> void:
	if entity.targetting_component.targeted_crab == null:
		entity.state_machine.change_state_str("Idle")
