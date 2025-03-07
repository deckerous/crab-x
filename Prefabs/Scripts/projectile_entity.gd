class_name ProjectileEntity
extends Entity

@export_group("Projectile Properties")
@export var speed : float = 1.0
@export var max_distance : float = 300.0
@export var fall_off_ratio : float = 0.8
@export var fall_off_constant : float = 0.03
@export var speed_before_destroy : float = 1.0
@export var collide_with_walls : bool = true
@export var collide_with_crabs: bool = true
@export var collide_with_enemies: bool = true

@onready var direction : Vector2 = Vector2.ZERO
@onready var destroy = $StateMachine/Destroy
@onready var collided = false

@onready var distance_elapsed : float = 0.0

@onready var origin_set = false
@onready var origin : Vector2 = Vector2.ZERO :
	set(value):
		origin = value
		origin_set = true

@onready var destroyed = false

func _physics_process(delta) -> void:
	super(delta)
	
	if origin_set:
		distance_elapsed = origin.distance_to(position)
		var elapsed_ratio = distance_elapsed / max_distance
		
		if elapsed_ratio >= fall_off_ratio:
			velocity += -velocity * fall_off_constant
		
		if ((distance_elapsed > max_distance) or (velocity.length() < speed_before_destroy)) and !destroyed:
			state_machine.change_state(destroy)
			destroyed = true
	
	var collision_info = move_and_collide(velocity)
	if !collided and collision_info:
		state_machine.change_state(destroy) 
		collided = true
	else: 
		return

func init_projectile(dir: Vector2) -> void:
	self.direction = dir
	velocity = dir * speed
