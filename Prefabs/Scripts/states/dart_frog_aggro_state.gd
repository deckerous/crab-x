extends State

# fade_in
# shoot
# fade_out
# change position
# repeat...

@export_group("Transition States")
@export var idle: State

@export_group("Projectile")
@export var projectile: PackedScene

@export_group("Behavior Timer Settings")
@export var time_before_invisible_min: float = 1.0
@export var time_before_invisible_max: float = 1.5
@export var time_while_invisible_min: float = 1.5
@export var time_while_invisible_max: float = 3.0

@onready var projectile_spawn_position = $ProjectileSpawnPosition
@onready var animation_player = $AnimationPlayer

var crab_pos = Vector2.ZERO

func _ready() -> void:
	
	animation_player.current_animation_changed.connect(_update_collision)

func enter() -> void:
	super()
	if entity.targetting_component.targeted_crab != null:
		crab_pos = entity.targetting_component.targeted_crab.global_position
	_shoot()

func process_physics(float) -> State:
	if entity.targetting_component.targeted_crab == null:
		return idle
	
	return null

func _shoot() -> void:
	if entity.targetting_component.targeted_crab != null:
		animation_player.play("fade_in")
		await get_tree().create_timer(animation_player.get_animation("fade_in").length).timeout
		
		if entity.targetting_component.targeted_crab != null:
			var inst = projectile.instantiate()
			inst.global_rotation = projectile_spawn_position.global_position.direction_to(entity.targetting_component.targeted_crab.global_position).angle() + PI/2.0
			inst.init_projectile(projectile_spawn_position.global_position.direction_to(entity.targetting_component.targeted_crab.global_position))
			entity.summon_projectile(inst, projectile_spawn_position.global_position)
		
		await get_tree().create_timer(randf_range(time_before_invisible_min, time_before_invisible_max)).timeout
		animation_player.play("fade_out")
		await get_tree().create_timer(animation_player.get_animation("fade_out").length).timeout
		_teleport()

func _teleport() -> void:
	if entity.targetting_component.targeted_crab != null:
		entity.global_position = crab_pos
		crab_pos = entity.targetting_component.targeted_crab.global_position
		
		await get_tree().create_timer(randf_range(time_while_invisible_min, time_while_invisible_max)).timeout
		_shoot()

func _update_collision(name: String) -> void:
	if name == "fade_in":
		$"../../CollisionBox".disabled = false
		$"../../HitboxComponent/CollisionShape2D".disabled = false
		$"../../HurtboxComponent/CollisionShape2D".disabled = false
	elif name == "fade_out":
		$"../../CollisionBox".disabled = true
		$"../../HitboxComponent/CollisionShape2D".disabled = true
		$"../../HurtboxComponent/CollisionShape2D".disabled = true
