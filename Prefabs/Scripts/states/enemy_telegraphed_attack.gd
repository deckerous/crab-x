class_name EnemyTelegraphState
extends State

@export_group("Transition States")
@export var roll_attack: State

@export_group("Telegraphed Projectile Scenes")
@export var telegraph_marker: PackedScene
@export var telegraph_projectile: PackedScene

@export_group("Telegraphed Attack Patterns")
@export var telegraphed_attack: Curve2D

var telegraphed_attack_points
var ta_index = 0
var ta_count = 5

@onready var projectile_spawn_position = $ProjectileSpawnPosition
@onready var cooldown_timer = $CooldownTimer
@onready var telegraph_buffer_timer = $TelegraphBufferTimer

var cooldown = false
var telegraph_buffer = false

func _ready() -> void:
	cooldown_timer.timeout.connect(func(): cooldown = false)
	telegraph_buffer_timer.timeout.connect(func(): telegraph_buffer = false)
	
	if telegraphed_attack:
		telegraphed_attack_points = telegraphed_attack.get_baked_points()

func enter() -> void:
	super()
	ta_count = 5

func process_physics(delta: float) -> State:
	super(delta)
	
	if ta_count == 0:
		return roll_attack
	
	# For when no attack pattern
	if entity.targetting_component.targeted_crab != null:
		if !cooldown and !telegraphed_attack:
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
		
		if !cooldown and !telegraph_buffer and telegraphed_attack and ta_count > 0:
			
			if ta_index < telegraphed_attack_points.size():
				
				var point = telegraphed_attack_points[ta_index]
				if int(roundf(point.y)) % 10 == 0:
					print(point)
					var marker_inst = telegraph_marker.instantiate()
					get_tree().root.add_child(marker_inst)
					marker_inst.global_position = entity.targetting_component.targeted_crab.global_position + point
					
					var projectile_inst = telegraph_projectile.instantiate()
					projectile_inst.global_rotation = projectile_spawn_position.global_position.direction_to(entity.targetting_component.targeted_crab.global_position + point).angle() + PI/2.0
					projectile_inst.init_projectile(projectile_spawn_position.global_position.direction_to(entity.targetting_component.targeted_crab.global_position + point))
					projectile_inst.marker_position = marker_inst.global_position
					projectile_inst.telegraph_marker = marker_inst
					entity.summon_projectile(projectile_inst, projectile_spawn_position.global_position)
					
					telegraph_buffer = true
					telegraph_buffer_timer.start()
				
				ta_index += 1
				
			elif ta_index >= telegraphed_attack_points.size():
				ta_index = 0
				cooldown = true
				cooldown_timer.start()
				ta_count -= 1
	
	return null
