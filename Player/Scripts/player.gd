extends Node2D

@export_group("Crab Movement Speeds")
@export var rally_point_move_speed : float = 75.0
@export var crab_moving_speed : float = 75.0

@export_group("Camera Properties")
@export var crosshair_dist_min : float = 15.0
@export var crosshair_dist_max : float = 140.0
@export var camera_mid_point_constant : float = 2.0

@onready var camera_2d = $Camera2D
@onready var crab_manager = $CrabManager
@onready var rally_point_crab_entity = crab_manager.get_child(0) # First crab = first rally point
@onready var crosshair = $Crosshair
@onready var rich_text_label = $PlayerUI/Control/HBoxContainer/RichTextLabel

@onready var viewport_w = get_viewport().get_visible_rect().size.x
@onready var viewport_h = get_viewport().get_visible_rect().size.y

@onready var coin_count : int = 0

@onready var crab_component = load("res://Prefabs/Scenes/crab_entity.tscn")

# For UI integration
var is_paused = false # Keep track of pause state
@onready var ui_instance = $ui

var mouse_pos = Vector2.ZERO
var move_dir = Vector2.ZERO

var game_over = false

func _ready():
	# Stop physics process until we see the navigation map sync,
	# should only take one physics frame.
	set_physics_process(false)
	call_deferred("navigation_map_setup")
	
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN

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
	if rally_point_crab_entity != null:
		var rally_dist_from_crosshair = rally_point_crab_entity.global_position.distance_to(crosshair.global_position)
		rally_dist_from_crosshair = clampf(rally_dist_from_crosshair, crosshair_dist_min, crosshair_dist_max)
		var mid_point_to_crosshair = rally_point_crab_entity.global_position.direction_to(crosshair.global_position).normalized() * (rally_dist_from_crosshair / camera_mid_point_constant)
		# Place camera at the midpoint between cursor and rally point
		camera_2d.global_position = rally_point_crab_entity.global_position + mid_point_to_crosshair
	
	mouse_pos = get_global_mouse_position()

func _physics_process(delta):
	if Input.is_action_just_pressed("exit"):
		toggle_pause() #for UI integration
		# get_tree().quit()
	
	if is_paused: #for UI integration
		return
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("fullscreen"):
		var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if fs:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	var crabs = crab_manager.get_children()
	game_over = crabs.size() == 0
	
	if !game_over:
		# If rally point crab dies, go to next available crab
		if rally_point_crab_entity == null: 
			rally_point_crab_entity = crab_manager.get_child(0)
			rally_point_crab_entity.is_rally = true
		
		if crabs.size() > 1:
			_update_crab_velocities(crabs)
		
		# Crosshair position update
		crosshair.global_position = mouse_pos
		
		# Rally point crab movement
		_update_rally_crab_velocity()
	
	else:
		_game_over()

func _update_rally_crab_velocity() -> void:
	if rally_point_crab_entity != null:
		move_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
		rally_point_crab_entity.velocity = move_dir * rally_point_move_speed
		if rally_point_crab_entity != null: rally_point_crab_entity.move_and_slide()

# Update crab velocities to move toward rally point
func _update_crab_velocities(crabs) -> void:
	for crab in crabs:
		if crab is CrabEntity and crab != rally_point_crab_entity and rally_point_crab_entity != null:
			crab.navigation_agent_2d.target_position = rally_point_crab_entity.global_position
			var curr_crab_position = crab.global_position
			var next_path_position = crab.navigation_agent_2d.get_next_path_position()
			var new_crab_velocity = curr_crab_position.direction_to(next_path_position).normalized() * crab_moving_speed
			
			if crab.navigation_agent_2d.is_navigation_finished():
				new_crab_velocity = lerp(new_crab_velocity, new_crab_velocity, 0.05)
			
			if crab.navigation_agent_2d.avoidance_enabled:
				crab.navigation_agent_2d.set_velocity(new_crab_velocity)
			else:
				crab._on_navigation_agent_2d_velocity_computed(crab.velocity)
			
			if crab.process_mode == Node.PROCESS_MODE_INHERIT:
				crab.move_and_slide()

func handle_loot(array: Array) -> void:
	print_debug(array)
	for item in array:
		match item:
			"Crab":
				var crab_instance = crab_component.instantiate()
				crab_instance.position = rally_point_crab_entity.position
				crab_manager.call_deferred("add_child", crab_instance)
			"Slingshot":
				for child in crab_manager.get_children():
					child.external_state_change("Slingshot")
          
				# $RallyPointCrabEntity.external_state_change("Slingshot")

			"Sheckle":
				coin_count += 1
				rich_text_label.text = str(coin_count)
			"Glock":
				for child in crab_manager.get_children():
					child.external_state_change("Glock")
				
func handle_entity_death() -> void:
	# TODO: Replace with more robust loot pools
	coin_count += 1
	rich_text_label.text = str(coin_count)

func _game_over() -> void:
	ui_instance._on_game_over()
	crosshair.hide()

func add_crabs(num: int) -> void:
	if num < 2: return
	

	for x in num-1:
		var crab_inst = crab_component.instantiate()
		crab_inst.position = rally_point_crab_entity.position + Vector2(10, 10)
		crab_manager.add_child(crab_inst)



func _on_shop_shop_closed(coins_left: Variant) -> void:
	coin_count = coins_left
	rich_text_label.text = str(coin_count)

# For UI integration
func toggle_pause():
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED
	ui_instance.toggle_pause_menu()

