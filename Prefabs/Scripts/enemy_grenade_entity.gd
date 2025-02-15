extends ProjectileEntity

@onready var marker_position = Vector2.ZERO
@onready var telegraph_marker = null
@onready var area_2d = $Area2D

func _ready() -> void:
	super()
	area_2d.area_entered.connect(_explode)

func _explode(area: Area2D) -> void:
	velocity = Vector2.ZERO
	animations.hide()
	state_machine.call_deferred("change_state_str" , "Destroy")
