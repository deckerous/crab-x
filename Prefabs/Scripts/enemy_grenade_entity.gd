extends ProjectileEntity

@onready var marker_position = Vector2.ZERO
@onready var telegraph_marker = null
@onready var area_2d = $Area2D

func _ready() -> void:
	super()
	hitbox_component.collision_shape_2d.set_deferred("disabled", true)
	area_2d.area_entered.connect(_explode)

func _explode(area: Area2D) -> void:
	hitbox_component.collision_shape_2d.set_deferred("disabled", false)
	velocity = Vector2.ZERO
	await get_tree().create_timer(0.1).timeout
	state_machine.call_deferred("change_state_str" , "Destroy")
