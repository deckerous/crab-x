extends CanvasLayer

@onready var coins = 10
@onready var coins_text = $Coin/CurrentCash

var items_purchased: Array = Array()

signal recieved_item(item)
signal shop_closed(coins_left)

func _on_shop_item_purchased(item: Variant) -> void:
	items_purchased.append(item)

func _enter(coins_start) -> void:
	coins_text.text = ": " + str(coins_start)
	coins = coins_start
	visible = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _leave() -> void:
	shop_closed.emit(coins)
	recieved_item.emit(items_purchased)
	items_purchased.clear()
	visible = false
