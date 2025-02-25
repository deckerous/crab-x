extends Control

@onready var crab_container = $CrabContainer

@onready var crab = load("res://Prefabs/Scenes/crab_entity.tscn")
@onready var crabs = []

@onready var viewport_w = get_viewport().get_visible_rect().size.x
@onready var viewport_h = get_viewport().get_visible_rect().size.y

func _physics_process(delta):
	if crabs.size() == 0:
		_spawn_crabs()
	
	if crabs.size() > 0:
		_update_crabs_pos()

func _spawn_crabs() -> void:
	var coords = Vector2(randi_range(8, viewport_w - 8), viewport_h)
	
	var num = randi_range(1, 8)
	print(num)
	for i in num:
		var inst = crab.instantiate()
		inst.global_position = Vector2(coords.x + randf_range(-16, 16), coords.y + i * 16)
		crab_container.add_child(inst)
		crabs.append(inst)

func _update_crabs_pos() -> void:
	for crab in crabs:
		if crab != null:
			crab.position.y -= 0.5
			if crab.position.y <= -128:
				crab.queue_free()
		else:
			crabs.remove_at(0)

func _on_new_game_button_pressed():
	print("New game button pressed")
	CrabLogs.log_stage_start("tutorial")
	get_tree().change_scene_to_file("res://Levels/Tutorial/tutorial_refactor.tscn") # TODO: replace with actual game scene

func _on_continue_button_pressed():
	print("Continue button pressed")
	# TODO: implement save system
	pass

func _on_settings_button_pressed():
	print("Settings button pressed")
	# TODO: implement settings screen
	pass

func _on_quit_button_pressed():
	print("Game was quit")
	get_tree().quit()
