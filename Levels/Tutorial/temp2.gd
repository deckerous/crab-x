extends Area2D

@export var i_hate_everything = ["I've spotted a dangerous enemy ahead, [shake rate=25level=10]prawn![/shake] Make sure to dodge his grenades, and remember...",
								 "[shake rate=25level=20]EVERY CRAB FOR THEMSELVES!!!!!!![/shake]"]

func pain_peko(body: Node2D) -> void:
	if body is CrabEntity:
		$"../DialogueHandler".tutorial_time(i_hate_everything)
		$"../Enemies/DummyBossEntity".process_mode = Node.PROCESS_MODE_INHERIT
		queue_free()
