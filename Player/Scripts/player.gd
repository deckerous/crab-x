extends Node2D

@export var rally_point_move_speed : float = 50.0
@export var camera_distance : float = 35.0
@export var crab_moving_speed : float = 50.0

@onready var camera_2d = $Camera2D
@onready var rally_point = $RallyPoint
@onready var crab_manager = $CrabManager
@onready var crosshair = $Crosshair

@onready var viewport_w = get_viewport().get_visible_rect().size.x
@onready var viewport_h = get_viewport().get_visible_rect().size.y

var mouse_pos = Vector2.ZERO
var move_dir = Vector2.ZERO

func _ready():
	# Stop physics process until we see the navigation map sync,
	# should only take one physics frame.
	set_physics_process(false)
	call_deferred("navigation_map_setup")

func navigation_map_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	set_physics_process(true)

func _input(event):
	if event is InputEventMouse:
		mouse_pos = Vector2(event.position.x - viewport_w/2.0, event.position.y - viewport_h/2.0)
		crosshair.global_position = get_global_mouse_position()
		print(mouse_pos)

func _process(delta):
	if move_dir != Vector2.ZERO:
		camera_2d.global_position = lerp(camera_2d.global_position, rally_point.global_position + move_dir * camera_distance, 0.05)
	else:
		camera_2d.global_position = lerp(camera_2d.global_position, rally_point.global_position, 0.01)

func _physics_process(delta):
	if Input.is_action_just_pressed("exit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	
	move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	
	# Update crab velocities to move toward rally point
	for crab in crab_manager.get_children():
		if crab is CharacterBody2D and crab is Crab:
			crab.navigation_agent_2d.target_position = rally_point.global_position
			var curr_crab_position = crab.global_position
			var next_path_position = crab.navigation_agent_2d.get_next_path_position()
			var new_crab_velocity = curr_crab_position.direction_to(next_path_position).normalized() * crab_moving_speed
			
			crab.global_rotation = crab.global_position.direction_to(get_global_mouse_position()).angle() + PI/2.0
			
			if crab.navigation_agent_2d.is_navigation_finished():
				new_crab_velocity = lerp(new_crab_velocity, new_crab_velocity * 0.9, 0.05)
			
			if crab.navigation_agent_2d.avoidance_enabled:
				crab.navigation_agent_2d.set_velocity(new_crab_velocity)
			else:
				crab._on_navigation_agent_2d_velocity_computed(crab.velocity)
			
			crab.move_and_slide()
	
	
	rally_point.global_rotation = rally_point.global_position.direction_to(get_global_mouse_position()).angle() + PI/2.0
	rally_point.velocity = move_dir * rally_point_move_speed
	rally_point.move_and_slide()
