class_name Credits
extends CanvasLayer

@export var credits_scroll_speed: float = 0.5
@export var credits_scroll_speed_fast: float = 5.0

@onready var crab_container: Node2D = $CrabContainer
@onready var credits_container: Control = $CreditsContainer
@onready var main_menu_button: Button = $CreditsContainer/MainMenuButton

@onready var crab = load("res://Prefabs/Scenes/crab_entity.tscn")
@onready var crabs = []

@onready var viewport_w = get_viewport().get_visible_rect().size.x
@onready var viewport_h = get_viewport().get_visible_rect().size.y

func _ready() -> void:
	AudioManager.play_bgm("spagetti")
	Transition.fade_out()
	main_menu_button.pressed.connect(_on_main_menu_button_pressed)

func _process(delta: float) -> void:
	if credits_container.position.y > -1080:
		if Input.is_action_pressed("progress_dialogue"):
			credits_container.position.y -= credits_scroll_speed_fast
		else:
			credits_container.position.y -= credits_scroll_speed
	
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

func _on_main_menu_button_pressed():
	AudioManager.stop_bgm()
	AudioManager.play_sfx("plus")
	Transition.fade_in()
	await Transition.animation_player.animation_finished
	get_tree().change_scene_to_file("res://UI/start_menu.tscn")
