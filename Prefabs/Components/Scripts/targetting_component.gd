extends Node2D

@onready var player_detection_area = $PlayerDetectionArea
@onready var collision_shape_2d = $PlayerDetectionArea/CollisionShape2D
@onready var ray_cast_2d = $RayCast2D

var targeted_crab: CrabEntity = null

var entities_detected: Array[Node2D]

func _ready() -> void:
	player_detection_area.body_entered.connect(_get_visible_bodies_on_enter)
	player_detection_area.body_exited.connect(_get_visible_bodies_on_exit)

func _get_visible_bodies_on_enter(body: Node2D) -> void:
	if body is CrabEntity and body.visible:
		entities_detected = player_detection_area.get_overlapping_bodies()

func _get_visible_bodies_on_exit(body: Node2D) -> void:
	if body is CrabEntity and body.visible and body == targeted_crab:
		entities_detected = player_detection_area.get_overlapping_bodies()

func _physics_process(delta: float):
	var distance_to_target = 0
	if targeted_crab != null:
		distance_to_target = ray_cast_2d.global_position.distance_to(targeted_crab.global_position)
		if distance_to_target > collision_shape_2d.shape.radius:
			targeted_crab = null
	
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
