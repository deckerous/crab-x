extends Level

@onready var dialogue_handler = $DialogueHandler
@onready var post_chest_dialogue = $Graphics/LootAndTriggers/TutorialTrigger2
@onready var post_dummy_dialogue = $Graphics/LootAndTriggers/TutorialTrigger4
@onready var post_shop_dialogue = $Graphics/LootAndTriggers/TutorialTrigger3
@onready var boss = $Enemies/DummyBossEntity

@onready var chests_opened = 0
@onready var dummies_killed = 0
@onready var enabled_boss_on_tutorial = false

func _ready() -> void:
	super()
	dialogue_handler.trigger_visible()

func _start_tutorial(text: Variant) -> void:
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
		
func _enable_boss(fuck_me) -> void:
	enabled_boss_on_tutorial = true

func _check_for_boss_enable() -> void:
	if enabled_boss_on_tutorial:
		boss.process_mode = Node.PROCESS_MODE_INHERIT

func _enable_boss_tutorial(_unused) -> void:
	post_shop_dialogue.visible = true
	post_shop_dialogue.process_mode = Node.PROCESS_MODE_INHERIT

func _boss_killed(_unused) -> void:
	level_complete = true

func _shop_tutorial_trigger(text: Variant) -> void:
	var shop_icon = $Graphics/LootAndTriggers/ShopIcon
	shop_icon.process_mode = Node.PROCESS_MODE_INHERIT
	shop_icon.visible = true
