class_name HurtboxComponent
extends Area2D

# inline setter to disable and enable collision shapes on
# the hurtbox when vulnerable is updated.
var vulnerable = true :
	set(value):
		vulnerable = value
		# Disable hurtbox collision shape when it is invulnerable,
		# reenable when turning vulernable again
		for child in get_children():
			if not child is CollisionShape2D and not child is CollisionPolygon2D: continue
			child.set_deferred("disabled", vulnerable)

# When a hitbox enters this hurtbox, connected to 
signal hurt(hitbox)
