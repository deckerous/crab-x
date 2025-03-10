class_name GunState
extends State

# Projectile info
@export_group("Projectile")
@export var projectile: PackedScene

@onready var bullet_spawn_position = $BulletSpawnPosition
@onready var cooldown_timer: Timer = $CooldownTimer

var cooldown = false
var projectile_fired = false

func _ready() -> void:
	cooldown_timer.timeout.connect(func(): cooldown = false)

# Override: Process player input for if they want to shoot
func process_physics(delta: float) -> State:
	super(delta)
	
	if (Input.is_action_just_pressed("shoot") or Input.is_action_pressed("shoot")) and !cooldown and !PlayerVariable.in_shop:
		var inst = projectile.instantiate()
		inst.global_rotation = bullet_spawn_position.global_position.direction_to(get_global_mouse_position()).angle() + PI/2.0
		inst.init_projectile(bullet_spawn_position.global_position.direction_to(get_global_mouse_position()))
		entity.summon_projectile(inst, bullet_spawn_position.global_position)
		inst.origin = bullet_spawn_position.global_position
		cooldown = true
		projectile_fired = true
		cooldown_timer.start()
	
	return null
