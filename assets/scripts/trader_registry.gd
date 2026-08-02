class_name TraderRegistry extends Node

static var instance: TraderRegistry
var traders: Dictionary[String, TraderData] = {}

func _init():
	if instance == null:
		instance = self
	
func _ready():
	load_traders_from_json()

func load_traders_from_json():
	var file = FileAccess.open("res://data_resource/traders_config.json", FileAccess.READ)
	if not file:
		print("Could not open traders config file")
		return
	
	var json_string = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("Error parsing traders JSON: ", json.parse_error_string)
		return
	
	var traders_data = json.data
	
	for trader_id in traders_data:
		var trader_info = traders_data[trader_id]
		var trader_data = TraderData.new()
		
		trader_data.trader_name = trader_info.get("name", "")
		trader_data.trader_type = trader_info.get("type", "general")
		trader_data.sell_price_multiplier = trader_info.get("sell_price_multiplier", 1.0)
		trader_data.buy_price_multiplier = trader_info.get("buy_price_multiplier", 1.0)
		
		# Convert sell items
		if "sell_items" in trader_info:
			for item_name in trader_info["sell_items"]:
				var item_data = trader_info["sell_items"][item_name]
				var item_props = ItemProps.new()
				item_props.value = item_data.get("value", 0)
				item_props.amount = item_data.get("amount", 0)
				trader_data.sell_items[item_name] = item_props
		
		# Convert buy items
		if "buy_items" in trader_info:
			for item_name in trader_info["buy_items"]:
				var item_data = trader_info["buy_items"][item_name]
				var item_props = ItemProps.new()
				item_props.value = item_data.get("value", 0)
				item_props.amount = item_data.get("amount", -1) # -1 means unlimited buying
				trader_data.buy_items[item_name] = item_props
		
		traders[trader_id] = trader_data

func get_trader_data(trader_id: String) -> TraderData:
	return traders.get(trader_id, null)

func get_all_traders() -> Dictionary[String, TraderData]:
	return traders

func register_trader(trader_id: String, trader_data: TraderData):
	traders[trader_id] = trader_data

static func get_instance() -> TraderRegistry:
	if instance == null:
		instance = TraderRegistry.new()
	return instance