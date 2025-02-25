extends Level

@onready var dialogue_handler = $DialogueHandler
@onready var post_chest_dialogue = $Graphics/LootAndTriggers/KillDummies
@onready var post_dummy_dialogue = $Graphics/LootAndTriggers/Shopping
@onready var post_shop_dialogue = $Graphics/LootAndTriggers/KillBoss
@onready var boss = $Enemies/DummyBossEntity

@onready var chests_opened = 0
@onready var dummies_killed = 0
@onready var enabled_boss_on_tutorial = false
@onready var tut_boss_killed = false


func _ready() -> void:
	super()
	CrabLogs.log_tutorial_step("StartTutorial")
	dialogue_handler.trigger_visible()

func _start_tutorial(tutorial_part, text: Variant) -> void:
	CrabLogs.log_tutorial_step(tutorial_part)
	dialogue_handler.tutorial_time(text)

func _handle_chests(loot) -> void:
	chests_opened += 1
	if chests_opened == 3:
		post_chest_dialogue.visible = true
		post_chest_dialogue.process_mode = Node.PROCESS_MODE_INHERIT

func _handle_kills(_unused) -> void:
	dummies_killed += 1
	if dummies_killed == 3:
		post_dummy_dialogue.visible = true
		post_dummy_dialogue.process_mode = Node.PROCESS_MODE_INHERIT
		
func _enable_boss(node_name, text) -> void:
	enabled_boss_on_tutorial = true

func _check_for_boss_enable() -> void:
	if enabled_boss_on_tutorial and !tut_boss_killed:
		boss.process_mode = Node.PROCESS_MODE_INHERIT

func _enable_boss_tutorial(_unused) -> void:
	post_shop_dialogue.visible = true
	post_shop_dialogue.process_mode = Node.PROCESS_MODE_INHERIT

func _boss_killed(_unused) -> void:
	tut_boss_killed = true
	level_complete_func()

func _shop_tutorial_trigger(node_name, text) -> void:
	var shop_icon = $Graphics/LootAndTriggers/ShopIcon
	shop_icon.process_mode = Node.PROCESS_MODE_INHERIT
	shop_icon.visible = true
