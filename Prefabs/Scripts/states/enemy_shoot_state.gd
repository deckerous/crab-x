class_name EnemyShootState
extends State

@export_group("Transition states")
@export var wander: State

@export_group("Projectile")
@export var projectile: PackedScene

@onready var projectile_spawn_position = $ProjectileSpawnPosition
@onready var cooldown_timer = $CooldownTimer

var cooldown = false

func _ready() -> void:
	cooldown_timer.timeout.connect(func(): cooldown = false)

func process_physics(delta: float) -> State:
	super(delta)
	
	print(entity.targetting_component.targeted_crab)
	
	if entity.targetting_component.targeted_crab != null:
		if !cooldown:
			var inst = projectile.instantiate()
			inst.global_rotation = projectile_spawn_position.global_position.direction_to(entity.targetting_component.targeted_crab.global_position).angle() + PI/2.0
			inst.init_projectile(projectile_spawn_position.global_position.direction_to(entity.targetting_component.targeted_crab.global_position))
			entity.summon_projectile(inst, projectile_spawn_position.global_position)
			cooldown = true
			cooldown_timer.start()
	else:
		return wander
	
	return null
