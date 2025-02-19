class_name EnemyEntity
extends Entity

@export var flip_when_aiming: bool = false

@onready var targetting_component

func _ready() -> void:
	super()
	targetting_component = find_child("TargettingComponent")

func _physics_process(delta) -> void:
	super(delta)
	if flip_when_aiming and targetting_component.targeted_crab:
		
		var dir_to_crab = self.global_position.direction_to(targetting_component.targeted_crab.global_position)
		if dir_to_crab.x < 0.0:
			#self.scale.y = -1
			#self.rotation_degrees = 180
			var nodes = [$Animations, $CollisionBox, $CollisionShape2D, $HitboxComponent, $HurtboxComponent, $StateMachine/Aggro/ProjectileSpawnPosition]
			for node in nodes:
				node.scale.y = -1
				node.rotation_degrees = 180
		else:
			#self.scale.y = 1
			#self.rotation_degrees = 0
			var nodes = [$Animations, $CollisionBox, $CollisionShape2D, $HitboxComponent, $HurtboxComponent, $StateMachine/Aggro/ProjectileSpawnPosition]
			for node in nodes:
				node.scale.y = 1
				node.rotation_degrees = 0
	

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
