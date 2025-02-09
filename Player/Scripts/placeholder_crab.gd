class_name Crab
extends CharacterBody2D

@onready var navigation_agent_2d = $NavigationAgent2D

func _on_navigation_agent_2d_velocity_computed(safe_velocity):
	velocity = safe_velocity
