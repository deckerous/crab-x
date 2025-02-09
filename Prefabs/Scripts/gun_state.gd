class_name GunState
extends BaseState

# projectile properties
@export_group("Projectile properties")
@export var projectile_damage: float
@export var projectile: PackedScene

@onready var bullet_spawn_position = $BulletSpawnPosition

func _physics_process(delta):
	if Input.is_action_just_pressed("shoot") and state_machine.curr_state == self.name:
		var inst = projectile.instantiate()
		#inst.hitbox_component.damage = projectile_damage
		inst.global_rotation = bullet_spawn_position.global_position.direction_to(get_global_mouse_position()).angle() + PI/2.0
		inst.dir = bullet_spawn_position.global_position.direction_to(get_global_mouse_position())
		summon_projectile(inst, bullet_spawn_position.global_position)

func _process(delta):
	if state_machine.curr_state == self.name:
		if Input.is_action_just_pressed("empty"):
			state_machine.change_state("Empty")
		elif Input.is_action_just_pressed("slingshot") and self.name != "Slingshot":
			state_machine.change_state("Slingshot")
		elif Input.is_action_just_pressed("glock") and self.name != "Glock":
			state_machine.change_state("Glock")
		elif Input.is_action_just_pressed("rpg") and self.name != "RPG":
			state_machine.change_state("RPG")
