extends AnimationPlayer

@onready var rock = get_parent()
@onready var rock_speed_initial = rock.velocity.length()

func _process(delta: float) -> void:
	print(rock_speed_initial)
	if rock_speed_initial > rock.velocity.length():
		var speed_scale_ratio = rock.velocity.length() / rock_speed_initial
		speed_scale = speed_scale_ratio
