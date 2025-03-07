extends Camera2D

@onready var enemy_detected_area = $EnemyDetectedArea
@onready var control = $"../PlayerUI/Control"

@onready var viewport_w = get_viewport().get_visible_rect().size.x
@onready var viewport_h = get_viewport().get_visible_rect().size.y

@onready var enemy_detected_icon = load("res://Prefabs/Scenes/misc/enemy_detected_icon.tscn")

func _ready() -> void:
	enemy_detected_area.body_entered.connect(_spawn_detection_icon)

func _spawn_detection_icon(body: Node2D) -> void:
	var enemy_local_pos = to_local(body.global_position)
	enemy_local_pos += Vector2(viewport_w/2, viewport_h/2)
	var inst = enemy_detected_icon.instantiate()
	#inst.position = Vector2(clampf(enemy_local_pos.x, -viewport_w/2 + 24, viewport_w/2 - 24), clampf(enemy_local_pos.y, -viewport_h/2 + 24, viewport_h/2 - 24))
	inst.position = Vector2(clampf(enemy_local_pos.x, 16, viewport_w - 16), clampf(enemy_local_pos.y, 16, viewport_h - 24))
	control.add_child(inst)
