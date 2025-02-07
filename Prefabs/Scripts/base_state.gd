class_name BaseState

extends Node2D

# base properties
@export_group("Base properties")
@export var anim_name: String
@export var next_state: String
@export var duration: float

# velocity control
@export_group("Enter Velocity Control", "enter")
@export var enter_use_control: bool
@export var enter_vel_x: float
@export var enter_vel_y: float
@export var enter_speed: float

@onready var state_machine = $".."
@onready var anims = $"../../CharacterBody2D/AnimatedSprite2D"
@onready var entity = $"../.."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func run() -> void:
	# change animation
	anims.animation = anim_name
	
	# check enter velocity
	if enter_use_control:
		var enter_vel = Vector2(enter_vel_x, enter_vel_y).normalized() * enter_speed
		set_velocity(enter_vel)
	
	# set state timeout duration
	var timer = Timer.new()
	timer.name = "StateTimer"
	timer.one_shot = true
	timer.wait_time = duration
	timer.autostart = true
	timer.timeout.connect(state_machine.change_state.bind(next_state))
	state_machine.add_child(timer)
	
func set_velocity(vel: Vector2) -> void:
	entity.set_velocity(vel)
	
func summon_projectile(proj: Node2D, pos: Vector2) -> void:
	entity.summon_projectile(proj, pos)
