extends State

@export_group("Transition States")
@export var idle: State

@export_group("Projectile")
@export var projectile: PackedScene

@onready var projectile_spawn_positions_root = $ProjectileSpawnPositionsRoot
@onready var cooldown_timer = $CooldownTimer
@onready var puff_up_timer = $PuffUpTimer

var cooldown = false

func _ready() -> void:
	cooldown_timer.timeout.connect(func(): 
		cooldown = false
		animations.frame = 0
	)
	puff_up_timer.timeout.connect(func(): animations.frame = 1)

func enter() -> void:
	super()
	animations.pause()

func process_physics(delta: float) -> State:
	super(delta)
	
	if entity.targetting_component.targeted_crab != null:
		if !cooldown:
			for proj_pos in projectile_spawn_positions_root.get_children():
				var inst = projectile.instantiate()
				inst.global_rotation = proj_pos.global_position.direction_to(entity.global_position).angle() + -PI/2.0
				inst.init_projectile(-proj_pos.global_position.direction_to(entity.global_position))
				entity.summon_projectile(inst, proj_pos.global_position)
			
			cooldown = true
			cooldown_timer.start()
			puff_up_timer.start()
			#animations.frame = 1
	else:
		return idle
	
	return null
