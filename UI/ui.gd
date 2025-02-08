extends CanvasLayer

class_name ui
signal game_started
var game_score = 0

@onready var during_game_screen = $during_game_screen
@onready var end_of_game_screen = $end_of_game_screen

func _ready() -> void:
	$during_game_screen.text = "%d" % 0

func update_points(points: int):
	game_score = points

func on_game_over():
	during_game_screen.visible = false
	end_of_game_screen.visible = true
	$end_of_game_screen/end_of_game_score_display/score_output.text = "%d" % game_score

func _on_restart_button_pressed() -> void: 
	get_tree().reload_current_scene()
