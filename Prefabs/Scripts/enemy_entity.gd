class_name EnemyEntity
extends Entity

@export var flip_when_aiming: bool = false
@export var diff_flip: bool = false

@onready var targetting_component

@onready var circle_explosion = load("res://Prefabs/Scenes/misc/explosion_circle.tscn")

func _ready() -> void:
	super()
	targetting_component = find_child("TargettingComponent")

func _physics_process(delta) -> void:
	super(delta)
	if flip_when_aiming and targetting_component.targeted_crab:
		
		var dir_to_crab = Vector2.ZERO
		if targetting_component.targeted_crab != null:
			dir_to_crab = self.global_position.direction_to(targetting_component.targeted_crab.global_position)
		_flip_h(dir_to_crab)
	
	if diff_flip and targetting_component.targeted_crab:
		var dir_to_crab = Vector2.ZERO
		if targetting_component.targeted_crab != null:
			dir_to_crab = self.global_position.direction_to(targetting_component.targeted_crab.global_position)
		_diff_flip_h(dir_to_crab)

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity

func _flip_h(dir: Vector2) -> void:
	if dir.x < 0.0:
		var nodes = [$Animations, $CollisionBox, $CollisionShape2D, $HitboxComponent, $HurtboxComponent, $StateMachine/Aggro/ProjectileSpawnPosition]
		for node in nodes:
			node.scale.y = -1
			node.rotation_degrees = 180
	else:
		var nodes = [$Animations, $CollisionBox, $CollisionShape2D, $HitboxComponent, $HurtboxComponent, $StateMachine/Aggro/ProjectileSpawnPosition]
		for node in nodes:
			node.scale.y = 1
			node.rotation_degrees = 0

func _diff_flip_h(dir: Vector2) -> void:
	if dir.x < 0.0:
		self.scale.y = -1
		self.rotation_degrees = 180
	else:
		self.scale.y = 1
		self.rotation_degrees = 0
	
	$TargettingComponent.scale.y = 1
	$TargettingComponent.rotation_degrees = 0

func _on_death() -> void:
	if self.is_in_group("boss"):
		AudioManager.play_sfx("bigDefeat")
		var inst = circle_explosion.instantiate()
		inst.global_position = global_position
		get_parent().add_child(inst)
	else:
		AudioManager.play_sfx("smallDefeat")
