extends Node2D
class_name Player

@export_group("Crab Movement Properties")
@export var rally_point_move_speed : float = 75.0
@export var crab_moving_speed : float = 75.0
@export var crab_speed_up_dist: float = 35.0
@export var crab_speed_up_factor: float = 3.0
@export var crab_pathfind_factor: float = 0.75
@export var crab_move_dir_factor: float = 0.5

@export_group("Camera Properties")
@export var crosshair_dist_min : float = 15.0
@export var crosshair_dist_max : float = 140.0
@export var camera_mid_point_constant : float = 2.0

@onready var level: Node2D = $".."

@onready var camera_2d = $Camera2D
@onready var crab_manager = $CrabManager
@onready var rally_point_crab_entity = crab_manager.get_child(0) # First crab = first rally point
@onready var crosshair = $Crosshair
@onready var rich_text_label = $PlayerUI/Control/HBoxContainer/RichTextLabel

@onready var viewport_w = get_viewport().get_visible_rect().size.x
@onready var viewport_h = get_viewport().get_visible_rect().size.y

@onready var crab_component = load("res://Prefabs/Scenes/crab_entity.tscn")

# For UI integration
@onready var ui_instance = $ui
@onready var player_ui = $PlayerUI

var coin_count : int = 0
var crab_count : int = 0
var cur_weapon = "None"
var kill_count : int = 0

var mouse_pos = Vector2.ZERO
var move_dir = Vector2.ZERO

var last_damage_instance_source: String
var logged_player_death: bool = false
var game_over = false
var game_over_state = false

func _ready():
	# Stop physics process until we see the navigation map sync,
	# should only take one physics frame.
	set_physics_process(false)
	call_deferred("navigation_map_setup")
	
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED_HIDDEN
	
	rally_point_crab_entity.is_rally = true

func navigation_map_setup():
	# Wait for the first physics frame so the NavigationServer can sync.
	await get_tree().physics_frame
	set_physics_process(true)

func _process(delta):
	# TODO: Temp coin incrementer
	if Input.is_action_just_pressed("coin_up"):
		#coin_count += 1
		#rich_text_label.text = str(coin_count)
		add_coin()
		
	# Camera controls
	if rally_point_crab_entity != null:
		var rally_dist_from_crosshair = rally_point_crab_entity.global_position.distance_to(crosshair.global_position)
		rally_dist_from_crosshair = clampf(rally_dist_from_crosshair, crosshair_dist_min, crosshair_dist_max)
		var mid_point_to_crosshair = rally_point_crab_entity.global_position.direction_to(crosshair.global_position).normalized() * (rally_dist_from_crosshair / camera_mid_point_constant)
		# Place camera at the midpoint between cursor and rally point
		camera_2d.global_position = rally_point_crab_entity.global_position + mid_point_to_crosshair
	
	mouse_pos = get_global_mouse_position()

func _physics_process(delta):
	PlayerVariable.num_coins = coin_count
	PlayerVariable.num_crabs = crab_count
	
	
	var crabs = crab_manager.get_children()
	crab_count = crabs.size() # Update crab count
			
	if Input.is_action_just_pressed("exit"):
		toggle_pause()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	if Input.is_action_just_pressed("fullscreen"):
		var fs = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
		if fs:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	if PlayerVariable.in_shop == true:
		$PlayerUI.visible = false
	else:
		$PlayerUI.visible = true

	PlayerVariable.num_crabs = crabs.size()
	game_over = crabs.size() == 0
	
	if !game_over:
		# Reset logging varaible
		logged_player_death = false
		
		# If rally point crab dies, go to next available crab
		if rally_point_crab_entity == null: 
			rally_point_crab_entity = crab_manager.get_child(0)
			rally_point_crab_entity.is_rally = true
		
		# Rally point crab movement
		_update_rally_crab_velocity()
		
		if crabs.size() > 1:
			crab_count = crabs.size()
			_update_crab_velocities(crabs)
		
		# Crosshair position update
		crosshair.global_position = mouse_pos
	elif game_over and !game_over_state:
		game_over_state = true
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
			
			var rally_distance = crab.global_position.distance_to(rally_point_crab_entity.global_position)
			var new_crab_velocity = (curr_crab_position.direction_to(next_path_position).normalized()) * crab_moving_speed
			if move_dir != Vector2.ZERO and rally_distance < crab_speed_up_dist:
				new_crab_velocity = (curr_crab_position.direction_to(next_path_position).normalized() * crab_pathfind_factor + move_dir * crab_move_dir_factor) * crab_moving_speed
			
			if rally_distance > crab_speed_up_dist:
				new_crab_velocity *= crab_speed_up_factor
			
			if crab.navigation_agent_2d.is_navigation_finished():
				#new_crab_velocity = lerp(new_crab_velocity, new_crab_velocity, 0.05)
				new_crab_velocity = lerp(new_crab_velocity, crab.velocity, 0.05)
			
			if crab.navigation_agent_2d.avoidance_enabled:
				crab.navigation_agent_2d.set_velocity(new_crab_velocity)
			else:
				crab._on_navigation_agent_2d_velocity_computed(new_crab_velocity)
			
			if crab.process_mode == Node.PROCESS_MODE_INHERIT:
				
				crab.move_and_slide()
			
			if (crab.global_position - rally_point_crab_entity.global_position).length() > 200:
				crab.global_position = rally_point_crab_entity.global_position

func _unhandled_input(event):
	if PlayerVariable.in_shop:
		get_viewport().set_input_as_handled()

func handle_loot(array: Array) -> void:
	for item in array:
		match item:
			"Crab":
				var crab_inst = crab_component.instantiate()
				crab_inst.position = rally_point_crab_entity.position + Vector2(10, 10)
				crab_manager.add_child(crab_inst)
				PlayerVariable.num_crabs += 1
				
				match cur_weapon:
					"None":
						change_weapon(level.WEAPONS.EMPTY)
					"Slingshot":
						change_weapon(level.WEAPONS.SLINGSHOT)
					"Glock":
						change_weapon(level.WEAPONS.GLOCK)
					"RPG":
						change_weapon(level.WEAPONS.RPG)
					"Sniper":
						change_weapon(level.WEAPONS.SNIPER)
					
			"Slingshot":
				change_weapon(level.WEAPONS.SLINGSHOT)
			"Coin":
				add_coin()
			"Glock":
				change_weapon(level.WEAPONS.GLOCK)
			"RPG":
				change_weapon(level.WEAPONS.RPG)
			"Sniper":
				change_weapon(level.WEAPONS.SNIPER)

func change_weapon(state) -> void:
	var str = "None"
	match state:
		level.WEAPONS.SLINGSHOT:
			str = "Slingshot"
		level.WEAPONS.GLOCK:
			str = "Glock"
		level.WEAPONS.RPG:
			str = "RPG"
		level.WEAPONS.SNIPER:
			str = "Sniper"
		level.WEAPONS.EMPTY:
			str = "Empty"
	
	cur_weapon = str
	for child in crab_manager.get_children():
		child.external_state_change(str)
	PlayerVariable.cur_weapon = str

func handle_entity_death(name) -> void:
	# TODO: Replace with more robust loot pools
	#coin_count += 1
	#rich_text_label.text = str(coin_count)
	#if !PlayerVariable.debug:
	#	Analytics.add_event("Player killed enemy " + name)
	kill_count += 1
	add_coin()
	print("Kill count: ", kill_count)

func _game_over() -> void:
	# if !PlayerVariable.debug:
	# 	Analytics.add_event("Player died")
	if !logged_player_death:
		logged_player_death = true
		CrabLogs.log_player_death(last_damage_instance_source)
	crosshair.hide()
	player_ui.hide()
	ui_instance._on_game_over() 
	
	await get_tree().create_timer(1.0).timeout
	
	Transition.animation_player.speed_scale = 0.5
	Transition.fade_in()
	await Transition.animation_player.animation_finished
	Transition.animation_player.speed_scale = 1.0
	
	get_tree().reload_current_scene()

func add_crabs(num: int) -> void:
	if num < 2: return
	AudioManager.play_bgm("plus")
	var i = 1
	for x in num-1:
		var crab_inst = crab_component.instantiate()
		crab_inst.position = rally_point_crab_entity.position + Vector2(-10 + 20 * x, 20)
		crab_inst.velocity = Vector2.DOWN
		crab_manager.add_child(crab_inst)
		PlayerVariable.num_crabs += 1
		i += 1

func _on_shop_shop_closed(coins_left: Variant) -> void:
	coin_count = coins_left
	PlayerVariable.num_coins = coins_left
	rich_text_label.text = str(coin_count)
	PlayerVariable.in_shop = false

# For UI integration
func toggle_pause():
	if not PlayerVariable.in_shop:
		Input.mouse_mode = Input.MOUSE_MODE_CONFINED
		ui_instance.toggle_pause_menu()

func add_coin():
	AudioManager.play_sfx("coin")
	coin_count += 1
	PlayerVariable.num_coins = coin_count
	rich_text_label.text = " " + str(coin_count)

func _on_crab_entity_changed_last_damaged_by(entity: Node2D) -> void:
	last_damage_instance_source = entity.entity_id if entity.entity_id != "" else "unknown"
