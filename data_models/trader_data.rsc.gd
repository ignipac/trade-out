class_name TraderData extends Resource

@export var trader_type: String # e.g., "blacksmith", "textile", "food", etc.

# Items this trader sells to the player
@export var sell_items: Dictionary[String, ItemProps] = {}

# Items this trader buys from the player  
@export var buy_items: Dictionary[String, ItemProps] = {}

