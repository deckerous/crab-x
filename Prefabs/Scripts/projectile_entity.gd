class_name ProjectileEntity
extends Entity

@export var speed : float = 0.0
@export var collide_with_walls : bool = true
@export var collide_with_crabs: bool = true
@export var collide_with_enemies: bool = true

@onready var direction : Vector2 = Vector2.ZERO

@onready var destroy = $StateMachine/Destroy

@onready var collided = false

func _physics_process(delta) -> void:
	super(delta)
	
	var collision_info = move_and_collide(velocity)
	if !collided and collision_info:
		state_machine.change_state(destroy) 
		collided = true
	else: 
		return

func init_projectile(dir: Vector2) -> void:
	self.direction = dir
	velocity = dir * speed
