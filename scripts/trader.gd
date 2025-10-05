extends Area2D

@export var canvas: CanvasLayer

var maybe_load_dynamically: String = "res://ui/ui_shop.tscn"
var player = null

@onready var ui_shop := $UI/UIShop

func _ready() -> void:
	Utility.add_action_for_key("trade", KEY_E)

	body_entered.connect(func(body) -> void:
		if body is FILE_PATH.PLAYER:
			# load ui to trade
			player = body
			print_debug("player can trade")
	)

	body_exited.connect(func(_body) -> void:
		player = null
		unload_shop_ui()
	)

	#region Shop
	ui_shop.buy_button.pressed.connect(func() -> void:
		if player == null:
			return
		
		print_debug("player wants to buy")

		if has_node("sfx_click"):
			$sfx_click.play()
		else:
			var sfx = Utility.create_sfx_player(FILE_PATH.SFX_CLICK)
			add_child(sfx)
			sfx.name = "sfx_click"
			sfx.play()

		# Implement buying logic here
	)
	ui_shop.sell_button.pressed.connect(func() -> void:
		if player == null:
			return
		
		print_debug("player wants to sell")

		if has_node("sfx_click"):
			$sfx_click.play()
		else:
			var sfx = Utility.create_sfx_player(FILE_PATH.SFX_CLICK)
			add_child(sfx)
			sfx.name = "sfx_click"
			sfx.play()

		# Implement selling logic here
	)

	#endregion 

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("trade") and player != null:
		print_debug("player wants to trade")
		load_shop_ui()

func load_shop_ui() -> void:
	if not ui_shop:
		return
	
	var sfx = Utility.create_sfx_player(FILE_PATH.SFX_WHOOSH)
	add_child(sfx)
	sfx.name = "sfx_whoosh"
	sfx.play()
	ui_shop.visible = true

func unload_shop_ui() -> void:
	if not ui_shop:
		print_debug("No Shop UI found")
		return

	var sfx = $sfx_whoosh as AudioStreamPlayer
	if sfx:
		sfx.stream = FILE_PATH.SFX_WHOOSH_REVERSE
		sfx.play()
		sfx.finished.connect(func() -> void:
			sfx.queue_free()
		)
	
	ui_shop.visible = false
