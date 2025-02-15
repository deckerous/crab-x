class_name ProjectileEntity
extends Entity

@export var speed : float = 0.0
@export var collide_with_walls : bool = true

@onready var direction : Vector2 = Vector2.ZERO

@onready var destroy = $StateMachine/Destroy

func _physics_process(delta):
	super(delta)
	
	var collision_info = move_and_collide(velocity)
	if collide_with_walls:
		# If the projectile hits a tilemap with collision go to Destroy state
		if collision_info:
			var collider = collision_info.get_collider()
			if collider is CrabEntity:
				remove_collision_exception_with(collider)
			if collider is TileMapLayer or (collider is Entity and not collider is CrabEntity):
				state_machine.change_state(destroy)

func init_projectile(dir: Vector2) -> void:
	self.direction = dir
	velocity = dir * speed
