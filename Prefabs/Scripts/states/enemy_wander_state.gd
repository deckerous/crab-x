class_name EnemyWanderState
extends State

@export_group("Transition States")
@export var aggro: State

@onready var player_detection_area = $PlayerDetectionArea
@onready var collision_shape_2d = $PlayerDetectionArea/CollisionShape2D
@onready var ray_cast_2d = $RayCast2D

var crab_targetting

var entities_detected: Array[Node2D]

# Need to retain reference to initial body that enters to target them
# Keep track of all crab entities that enter to determine which one to shoot next

func _ready() -> void:
	player_detection_area.body_entered.connect(_enable_line_of_sight_check)
	player_detection_area.body_exited.connect(_disable_line_of_sight_check)

func _enable_line_of_sight_check(body: Node2D) -> void:
	if body is CrabEntity:
		entities_detected = player_detection_area.get_overlapping_bodies()

func _disable_line_of_sight_check(body: Node2D) -> void:
	if body is CrabEntity:
		entities_detected = player_detection_area.get_overlapping_bodies()

func process_physics(delta: float) -> State:
	
	if entities_detected.size() > 0:
		# check line of sight with raycast for every crab that enters
		# until enemy has line of sight with one of othem
		for entity in entities_detected:
			if entity is CrabEntity:
				ray_cast_2d.target_position = ray_cast_2d.global_position.direction_to(entity.global_position) * collision_shape_2d.shape.radius
				print()
				print(ray_cast_2d.target_position)
				print(entity.global_position)
				ray_cast_2d.force_raycast_update()
				var collider = ray_cast_2d.get_collider()
				
				# Check if there if the enemy can see this crab
				if collider and collider is CrabEntity:
					return aggro
	
	return null
