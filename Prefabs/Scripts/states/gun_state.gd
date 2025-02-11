class_name GunState
extends State

# Projectile info
@export_group("Projectile")
@export var projectile: PackedScene

@onready var bullet_spawn_position = $BulletSpawnPosition
@onready var cooldown_timer: Timer = $CooldownTimer

var cooldown = false

func _ready() -> void:
	cooldown_timer.timeout.connect(func(): cooldown = false)

# Override: Process player input for if they want to shoot
func process_input(event: InputEvent) -> State:
	super(event)
	
	if Input.is_action_just_pressed("shoot") and !cooldown:
		var inst = projectile.instantiate()
		inst.global_rotation = bullet_spawn_position.global_position.direction_to(get_global_mouse_position()).angle() + PI/2.0
		inst.init_projectile(bullet_spawn_position.global_position.direction_to(get_global_mouse_position()))
		entity.summon_projectile(inst, bullet_spawn_position.global_position)
		cooldown = true
		cooldown_timer.start()
	
	return null
