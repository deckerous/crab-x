class_name StartMenu
extends CanvasLayer

@onready var main_menu_screen: Node2D = $main_menu_screen
@onready var new_game_button: Button = $main_menu_screen/new_game_button
@onready var continue_button: Button = $main_menu_screen/continue_button

@onready var crab = load("res://Prefabs/Scenes/crab_entity.tscn")
@onready var crabs = []

@onready var viewport_w = get_viewport().get_visible_rect().size.x
@onready var viewport_h = get_viewport().get_visible_rect().size.y

signal finished_loading_sounds

func _ready() -> void:
	start_game()
	new_game_button.pressed.connect(_on_new_game_button_pressed)
	continue_button.pressed.connect(_on_continue_button_pressed)

func start_game() -> void:
	var level_num = PlayerVariable.load_values("Levels", "Current Level")
	if !PlayerVariable.config.has_section("Levels"):
		var tree = get_tree()
		tree.call_deferred("change_scene_to_file", PlayerVariable.tutorial_level)
	else:
		AudioManager.play_bgm("spagetti")
		Transition.fade_out()

func _physics_process(delta):
	if crabs.size() == 0:
		_spawn_crabs()
	
	if crabs.size() > 0:
		_update_crabs_pos()

func _spawn_crabs() -> void:
	var coords = Vector2(randi_range(8, viewport_w - 8), viewport_h)
	
	var num = randi_range(1, 8)
	for i in num:
		var inst: Node2D = crab.instantiate()
		inst.global_position = Vector2(coords.x + randf_range(-16, 16), coords.y + i * 16)
		main_menu_screen.add_child(inst)
		crabs.append(inst)

func _update_crabs_pos() -> void:
	for c in crabs:
		if c != null:
			c.position.y -= 0.5
			if c.position.y <= -128:
				c.queue_free()
		else:
			crabs.remove_at(0)

func _on_new_game_button_pressed():
	AudioManager.stop_bgm()
	AudioManager.play_sfx("plus")
	Transition.fade_in()
	await Transition.animation_player.animation_finished
	
	get_tree().change_scene_to_file(PlayerVariable.tutorial_level)

func _on_continue_button_pressed():
	AudioManager.stop_bgm()
	AudioManager.play_sfx("plus")
	print("Continue button pressed")
	# TODO: implement save system
	CrabLogs.log_player_continue()
	PlayerVariable.load_values("Levels", "Current Level")
	
	Transition.fade_in()
	await Transition.animation_player.animation_finished
	
	get_tree().change_scene_to_file(PlayerVariable.level[PlayerVariable.cur_level])
