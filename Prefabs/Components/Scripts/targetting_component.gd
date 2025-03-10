extends Node2D

@export_group("Targetting Settings")
@export var pathfind: bool = false

@onready var player_detection_area = $PlayerDetectionArea
@onready var collision_shape_2d = $PlayerDetectionArea/CollisionShape2D
@onready var ray_cast_2d = $RayCast2D
@onready var navigation_agent_2d = $NavigationAgent2D
@onready var entity = get_parent()
@onready var original_position = global_position

@onready var viewport_w = get_viewport().get_visible_rect().size.x
@onready var viewport_h = get_viewport().get_visible_rect().size.y

var targeted_crab: CrabEntity = null

var entities_detected: Array[Node2D]

func _ready() -> void:
	player_detection_area.body_entered.connect(_get_visible_bodies_on_enter)
	player_detection_area.body_exited.connect(_get_visible_bodies_on_exit)
	
	# navigation_agent_2d = find_child("NavigationAgent2D")

func _get_visible_bodies_on_enter(body: Node2D) -> void:
	if body is CrabEntity and body.visible:
		entities_detected = player_detection_area.get_overlapping_bodies()

func _get_visible_bodies_on_exit(body: Node2D) -> void:
	if body is CrabEntity and body.visible and body == targeted_crab:
		entities_detected = player_detection_area.get_overlapping_bodies()

func _physics_process(delta: float):
	var distance_to_target = 0
	if targeted_crab != null:
		if !(AudioManager.bgm_player.stream == AudioManager.bgm["beachBoss"]) and entity.process_mode == Node.PROCESS_MODE_INHERIT and entity.is_in_group("boss"):
			print(entity)
			AudioManager.play_bgm("beachBoss")
		distance_to_target = global_position.distance_to(targeted_crab.global_position)
		if distance_to_target > collision_shape_2d.shape.radius:
			targeted_crab = null
			if navigation_agent_2d: navigation_agent_2d.target_position = original_position
		else:
			if pathfind and navigation_agent_2d.target_position != targeted_crab.global_position:
				navigation_agent_2d.target_position = targeted_crab.global_position
	
	if targeted_crab == null:
		find_target()

func find_target() -> void:
	if entities_detected.size() > 0:
		# check line of sight with raycast for every crab that enters
		# until enemy has line of sight with one of othem
		for entity in entities_detected:
			if entity != null and entity is CrabEntity:
				ray_cast_2d.target_position = ray_cast_2d.global_position.direction_to(entity.global_position) * collision_shape_2d.shape.radius
				ray_cast_2d.force_raycast_update()
				var collider = ray_cast_2d.get_collider()
				
				# Check if the enemy can see this crab
				if collider and collider is CrabEntity:
					targeted_crab = collider
					if pathfind: navigation_agent_2d.target_position = collider.global_position
