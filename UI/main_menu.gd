extends Control

@onready var crab_container = $CrabContainer
@onready var continue_button = $main_menu_screen/continue_button
@onready var transition = $Transition
@onready var transition_animation_player = $Transition/AnimationPlayer

@onready var crab = load("res://Prefabs/Scenes/crab_entity.tscn")
@onready var crabs = []

@onready var viewport_w = get_viewport().get_visible_rect().size.x
@onready var viewport_h = get_viewport().get_visible_rect().size.y

func _ready() -> void:
	transition.visible = false
	var level_num = PlayerVariable.load_values("Levels", "Current Level")
	if !PlayerVariable.config.has_section("Levels"):
		transition.visible = true
		var tree = get_tree()
		tree.call_deferred("change_scene_to_file", "res://Levels/Tutorial/tutorial_refactor.tscn")

func _physics_process(delta):
	if crabs.size() == 0:
		_spawn_crabs()
	
	if crabs.size() > 0:
		_update_crabs_pos()

func _spawn_crabs() -> void:
	var coords = Vector2(randi_range(8, viewport_w - 8), viewport_h)
	
	var num = randi_range(1, 8)
	for i in num:
		var inst = crab.instantiate()
		inst.global_position = Vector2(coords.x + randf_range(-16, 16), coords.y + i * 16)
		crab_container.add_child(inst)
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
	CrabLogs.log_stage_start("tutorial")
	
	transition_animation_player.play("fade_in")
	transition.visible = true
	await transition_animation_player.animation_finished
	
	get_tree().change_scene_to_file("res://Levels/Tutorial/tutorial_refactor.tscn")

func _on_continue_button_pressed():
	CrabLogs.log_player_continue()
	PlayerVariable.load_values("Levels", "Current Level")
	
	transition_animation_player.play("fade_in")
	transition.visible = true
	await transition_animation_player.animation_finished
	
	get_tree().change_scene_to_file(PlayerVariable.level[PlayerVariable.cur_level])

func _on_settings_button_pressed():
	# TODO: implement settings screen
	pass

func _on_quit_button_pressed():
	get_tree().quit()
