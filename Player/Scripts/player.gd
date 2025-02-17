extends Node2D

@export var rally_point_move_speed : float = 75.0
@export var crab_moving_speed : float = 75.0
@export var crosshair_dist_min : float = 15.0
@export var crosshair_dist_max : float = 100.0
@export var camera_mid_point_constant : float = 2.0

@onready var camera_2d = $RallyPoint/Camera2D
@onready var rally_point = $RallyPoint
@onready var crab_manager = $CrabManager
@onready var crosshair = $Crosshair
@onready var rich_text_label = $PlayerUI/Control/HBoxContainer/RichTextLabel

@onready var viewport_w = get_viewport().get_visible_rect().size.x
@onready var viewport_h = get_viewport().get_visible_rect().size.y

@onready var coin_count : int = 0

# For UI integration
var is_paused = false # Keep track of pause state
@onready var ui_instance = $ui

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

func _process(delta):
	# TODO: Temp coin incrementer
	if Input.is_action_just_pressed("coin_up"):
		coin_count += 1
		rich_text_label.text = str(coin_count)
	
	# Camera controls
	var rally_dist_from_crosshair = rally_point.global_position.distance_to(crosshair.global_position)
	if rally_dist_from_crosshair > crosshair_dist_min and rally_dist_from_crosshair < crosshair_dist_max:
		# place camera about halfway from 
		var mid_point_to_crosshair = rally_point.global_position.direction_to(crosshair.global_position).normalized() * (rally_dist_from_crosshair / camera_mid_point_constant)
		camera_2d.global_position = rally_point.global_position + mid_point_to_crosshair
	
	mouse_pos = get_global_mouse_position()

func _physics_process(delta):
	if Input.is_action_just_pressed("exit"):
		toggle_pause() #for UI integration
		# get_tree().quit()
	
	if is_paused: #for UI integration
		return
	
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
				new_crab_velocity = lerp(new_crab_velocity, new_crab_velocity, 0.05)
			
			if crab.navigation_agent_2d.avoidance_enabled:
				crab.navigation_agent_2d.set_velocity(new_crab_velocity)
			else:
				crab._on_navigation_agent_2d_velocity_computed(crab.velocity)
			
			crab.move_and_slide()
	
	# Crosshair position update
	crosshair.global_position = mouse_pos
	
	# Rally point movement
	rally_point.global_rotation = rally_point.global_position.direction_to(get_global_mouse_position()).angle() + PI/2.0
	rally_point.velocity = move_dir * rally_point_move_speed
	rally_point.move_and_slide()

# For UI integration
func toggle_pause():
	if ui_instance:
		ui_instance.toggle_pause_menu()
		is_paused = not is_paused
	else:
		print("Error: ui is null")
