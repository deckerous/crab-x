extends EntityBase

@export var damage: float
@onready var dir: Vector2

@onready var airborne = $CharacterBody2D/StateMachine/Airborne

func _ready() -> void:
	super()
	hitbox_component.damage = damage
	airborne.enter_dir = dir
	state_machine.change_state("Airborne")
