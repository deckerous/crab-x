extends ProjectileEntity

func _physics_process(delta):
	super(delta)
	
	var collision_info = move_and_collide(velocity)
	if collide_with_walls:
		# If the projectile hits a tilemap with collision go to Destroy state
		if collision_info:
			var collider = collision_info.get_collider()
			if collider is TileMapLayer or (collider is Entity and !collider is CrabEntity):
				state_machine.change_state(destroy)
