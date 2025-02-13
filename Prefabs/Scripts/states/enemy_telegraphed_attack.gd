class_name EnemyTelegraphState
extends State

@export_group("Telegraphed Projectile Scenes")
@export var telegraph_marker: PackedScene
@export var telegraph_projectile: PackedScene

@onready var projectile_spawn_position = $ProjectileSpawnPosition
@onready var cooldown_timer = $CooldownTimer

var cooldown = false

func _ready() -> void:
	cooldown_timer.timeout.connect(func(): cooldown = false)

func process_physics(delta: float) -> State:
	super(delta)
	
	if entity.targetting_component.targeted_crab != null:
		if !cooldown:
			var marker_inst = telegraph_marker.instantiate()
			get_tree().root.add_child(marker_inst)
			marker_inst.global_position = entity.targetting_component.targeted_crab.global_position
			
			var projectile_inst = telegraph_projectile.instantiate()
			projectile_inst.global_rotation = projectile_spawn_position.global_position.direction_to(entity.targetting_component.targeted_crab.global_position).angle() + PI/2.0
			projectile_inst.init_projectile(projectile_spawn_position.global_position.direction_to(entity.targetting_component.targeted_crab.global_position))
			projectile_inst.marker_position = marker_inst.global_position
			projectile_inst.telegraph_marker = marker_inst
			entity.summon_projectile(projectile_inst, projectile_spawn_position.global_position)
			
			cooldown = true
			cooldown_timer.start()
	
	return null
