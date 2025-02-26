class_name ShopItem

extends HBoxContainer

@onready var base_shop = $"../../.."
@onready var label = $RichTextLabel
@onready var item_sprite = $TextureRect
@onready var purchase_button = $Button
@onready var cash_counter = $"../../../Coin/CurrentCash"

@export var item: Texture2D = load("res://Assets/Crabs/png/crab-rpg.png")
@export var item_string: String = "RPG"
@export var price: int = 5

signal purchased(item)

func _ready() -> void:
	label.text = "[right]" + str(price) + " coins   [/right]"
	item_sprite.texture = item
	purchase_button.custom_minimum_size = Vector2(90, 32)

func try_to_purchase() -> void:
	if base_shop.coins >= price:
		base_shop.coins -= price
		cash_counter.text = ": " + str(base_shop.coins)
		purchased.emit(item_string)
		purchase_button.text = "Purchased"
		purchase_button.disabled = true
		
