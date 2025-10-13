extends CharacterBody2D

@warning_ignore("unused_signal")
signal in_interactable_area(interactable_obj: Node) # pass the object that has the area 2d

var inventory := FILE_PATH.MODEL_INVENTORY.new()

var coins: int = 0
var is_using_touch: bool = false
var door: Node = null

var level: RefCounted = FILE_PATH.MODEL_LEVEL_STATE.new()

@export var ui: Control

func _ready() -> void:
	#region actions
	Utility.add_action_for_key("interact", KEY_E)
	#endregion

	add_to_group("player")

	#region setting ui data
	if ui:
		set_balance(20) # initialize balance display
		ui.set_quota_ui(level.exit_cost)
	#endregion

	in_interactable_area.connect(func(node) -> void:
		if node is FILE_PATH.DOOR:
			door = node
			print_debug("player is in door area")
			door.get_node("Sprite2D").modulate = Color.BLUE # highlight door
		else:
			print_debug("player left door area")
			door.get_node("Sprite2D").modulate = Color.YELLOW # reset door color
			door = null
	)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		print_debug("player wants to interact with door")
		if door != null and can_pay_exit_cost():
			pay_exit_cost()
			door.destroy()
		elif door != null and not can_pay_exit_cost():
			if has_node("sfx_error"): # play sound effect
				$sfx_error.play()
			else:
				var sfx = Utility.create_sfx_player(FILE_PATH.SFX_ERROR)
				add_child(sfx)
				sfx.volume_db = -10.0
				sfx.name = "sfx_error"
				sfx.stream = FILE_PATH.SFX_ERROR
				sfx.play()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var x_dir := (int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A)))
	var y_dir := (int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W)))

	var direction = Vector2(x_dir, y_dir).normalized()

	velocity = direction * 200.0
	move_and_slide()

func buy_item(item: String, price: int) -> bool:
	if coins >= price:
		set_balance(coins - price) # update balance
		
		if inventory.items.has(item):
			inventory.items[item] += 1 # update item quantity in data model
			ui.update_inventory_item(item).text = str(inventory.items[item]) # update item quantity in inventory ui
		else:
			inventory.items[item] = 1 # store item in data model
			ui.add_inventory_item(item).text = str(inventory.items[item]) # add item to inventory ui
		return true
	return false

func sell_item(item: String, price: int) -> bool:
	if inventory.items.has(item) and inventory.items[item] > 0:
		set_balance(coins + price) # update balance
		inventory.items[item] -= 1 # udate item quantity in data model
		ui.update_inventory_item(item).text = str(inventory.items[item]) # update item quantity in inventory ui
		if inventory.items[item] == 0:
			inventory.items.erase(item) # remove item from data model if qty is 0
			var item_ui = ui.get_inventory_item_ui(item)
			if item_ui:
				item_ui.queue_free() # remove item from inventory ui
		return true
	return false

func set_balance(amount: int) -> void:
	coins = amount
	ui.bal_label.text = str(coins)

func can_pay_exit_cost() -> bool:
	return coins >= level.exit_cost

func pay_exit_cost() -> bool:
	if can_pay_exit_cost():
		set_balance(coins - level.exit_cost)
		if has_node("sfx_pay"): # play sound effect
			$sfx_pay.play()
			return true
		else:
			var sfx = Utility.create_sfx_player(FILE_PATH.SFX_PAY)
			add_child(sfx)
			sfx.name = "sfx_pay"
			sfx.stream = FILE_PATH.SFX_PAY
			sfx.play()
		return true
	return false
