extends Area2D

# Simple trade system - give an item to get something else
# 
# Usage:
# 1. Add this script to an Area2D node in your scene
# 2. Configure the export variables in the inspector:
#    - required_item_type: what the player needs to give (e.g., "key")
#    - required_item_count: how many items needed
#    - reward_item_type: what the player gets in return (e.g., "coin")  
#    - reward_item_count: how many items given
# 3. Set up a CollisionShape2D as a child to define the trade area
# 4. Player walks into area and presses E (ui_accept) to trade
#
# Example configurations:
# - Trade 1 key for 5 coins: required="key"/1, reward="coin"/5
# - Trade 3 coins for 1 key: required="coin"/3, reward="key"/1
# - One-time special trade: can_trade_multiple_times=false

# What the trader wants from the player
@export var required_item_type: String = "key"
@export var required_item_count: int = 1

# What the trader gives to the player  
@export var reward_item_type: String = "coin"
@export var reward_item_count: int = 5

# Trade configuration
@export var can_trade_multiple_times: bool = false
@export var trade_prompt_text: String = "Press Enter	 to trade"

# Internal state
var has_traded: bool = false
var player_in_range: bool = false
var current_player: Node = null

signal trade_completed(item_given: String, item_received: String)
signal trade_failed(reason: String)

func _ready() -> void:
	# Connect area signals
	body_entered.connect(_on_player_entered)
	body_exited.connect(_on_player_exited)
	
	# Set up collision detection for player
	set_collision_layer(0)  # This area doesn't collide with anything
	set_collision_mask(1)   # Detect player on layer 1

func _process(_delta: float) -> void:
	# Check for trade input when player is in range
	if player_in_range and Input.is_action_just_pressed("ui_accept"):
		attempt_trade()

func _on_player_entered(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		current_player = body
		show_trade_prompt()

func _on_player_exited(body: Node) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		current_player = null
		hide_trade_prompt()

func show_trade_prompt() -> void:
	if can_trade() and get_tree().has_group("ui"):
		var ui = get_tree().get_first_node_in_group("ui")
		if ui and ui.has_method("show_prompt"):
			ui.show_prompt(trade_prompt_text)

func hide_trade_prompt() -> void:
	if get_tree().has_group("ui"):
		var ui = get_tree().get_first_node_in_group("ui")
		if ui and ui.has_method("hide_prompt"):
			ui.hide_prompt()

func can_trade() -> bool:
	# Check if trade is possible
	if has_traded and not can_trade_multiple_times:
		return false
		
	if not current_player:
		return false
		
	# Check if player has required items
	return player_has_required_items()

func player_has_required_items() -> bool:
	if not current_player:
		return false
		
	match required_item_type:
		"key":
			return current_player.key_count >= required_item_count
		"coin":
			if current_player.has_method("get_coin_count"):
				return current_player.get_coin_count() >= required_item_count
		_:
			# Generic item check - look for a property or method
			if current_player.has_method("has_item"):
				return current_player.has_item(required_item_type, required_item_count)
			elif current_player.get(required_item_type + "_count") != null:
				return current_player.get(required_item_type + "_count") >= required_item_count
	
	return false

func attempt_trade() -> void:
	if not can_trade():
		var reason = ""
		if has_traded and not can_trade_multiple_times:
			reason = "Already traded"
		elif not player_has_required_items():
			reason = "Not enough " + required_item_type + "s (need " + str(required_item_count) + ")"
		else:
			reason = "Cannot trade right now"
		
		trade_failed.emit(reason)
		show_trade_failure(reason)
		return
	
	# Remove required items from player
	if not remove_items_from_player():
		trade_failed.emit("Failed to remove items from player")
		return
	
	# Give reward items to player
	give_items_to_player()
	
	# Mark as traded
	has_traded = true
	
	# Emit success signal
	trade_completed.emit(required_item_type, reward_item_type)
	
	# Show success message
	show_trade_success()
	
	# Hide prompt if can't trade again
	if not can_trade_multiple_times:
		hide_trade_prompt()

func remove_items_from_player() -> bool:
	if not current_player:
		return false
		
	match required_item_type:
		"key":
			if current_player.key_count >= required_item_count:
				current_player.key_count -= required_item_count
				return true
		"coin":
			if current_player.has_method("remove_coins"):
				return current_player.remove_coins(required_item_count)
		_:
			# Generic item removal
			if current_player.has_method("remove_item"):
				return current_player.remove_item(required_item_type, required_item_count)
			elif current_player.get(required_item_type + "_count") != null:
				var current_count = current_player.get(required_item_type + "_count")
				if current_count >= required_item_count:
					current_player.set(required_item_type + "_count", current_count - required_item_count)
					return true
	
	return false

func give_items_to_player() -> void:
	if not current_player:
		return
		
	match reward_item_type:
		"key":
			current_player.key_count += reward_item_count
		"coin":
			if current_player.has_method("add_coins"):
				current_player.add_coins(reward_item_count)
			elif current_player.get("coin_count") != null:
				current_player.coin_count += reward_item_count
		_:
			# Generic item addition
			if current_player.has_method("add_item"):
				current_player.add_item(reward_item_type, reward_item_count)
			elif current_player.get(reward_item_type + "_count") != null:
				var current_count = current_player.get(reward_item_type + "_count")
				current_player.set(reward_item_type + "_count", current_count + reward_item_count)

func show_trade_success() -> void:
	var message = "Traded " + str(required_item_count) + " " + required_item_type
	message += " for " + str(reward_item_count) + " " + reward_item_type + "!"
	show_message(message, Color.GREEN)

func show_trade_failure(reason: String) -> void:
	show_message("Trade failed: " + reason, Color.RED)

func show_message(text: String, color: Color = Color.WHITE) -> void:
	print_debug("Trade: " + text)
	
	# Try to show message in UI if available
	if get_tree().has_group("ui"):
		var ui = get_tree().get_first_node_in_group("ui")
		if ui and ui.has_method("show_message"):
			ui.show_message(text, color)

# Helper function to reset trade state (useful for testing or special cases)
func reset_trade() -> void:
	has_traded = false

# Helper function to configure trade from code
func setup_trade(req_item: String, req_count: int, reward_item: String, reward_count: int) -> void:
	required_item_type = req_item
	required_item_count = req_count
	reward_item_type = reward_item
	reward_item_count = reward_count
