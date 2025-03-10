extends Entity
@onready var zoom = $AudioStreamPlayer2D

func _ready() -> void:
	super()
	zoom.pitch_scale = randf_range(0.95, 1.05)
	zoom.seek(randf_range(0, 2))
