extends Resource

var item_to_sell: Dictionary = {
	"silk": {
		"price": 5,
		"quantity": 10,
	},
	"steel": {
		"price": 15,
		"quantity": 5,
	},
}

var item_to_buy: Dictionary = {
	"wool": {
		"price": 3,
		"quantity": 20,
	},
	"wood": {
		"price": 8,
		"quantity": 10,
	},
}

func remove_stock_on_sell(item_name: String, quantity: int) -> void:
	if item_to_sell[item_name]["quantity"] < 0:
		return

	if item_name in item_to_sell:
		item_to_sell[item_name]["quantity"] -= quantity

func add_stock_on_buy(item_name: String, quantity: int) -> void:
	if item_name in item_to_buy:
		item_to_buy[item_name]["quantity"] += quantity
	else:
		item_to_buy[item_name] = {
			"price": 0,
			"quantity": quantity,
		}