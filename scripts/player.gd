extends CharacterBody2D

var coins: int = 20
var items := []
var key_count: int
var is_using_touch: bool = false

@onready var ui = $CanvasLayer/UI

@warning_ignore("unused_signal")
signal found_key

var input_touch := FILE_PATH.INPUT_TOUCH.new() # NOTE: rm & unique mobile input

func _ready() -> void:
	add_to_group("player")
	add_child(input_touch)

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
		ui.add_inventory_item(item) # add item to inventory ui
		items.append(item) # store item in data model
		return true

	print_debug("not enough coins")
	return false

func set_balance(amount: int) -> void:
	coins = amount
	ui.bal_label.text = str(amount)