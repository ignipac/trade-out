extends Area2D

@export var trader_data: TraderData
@export var trader_id: String = "" # ID to lookup trader in registry

var player = null

var item_1 = 100.0

@export var ui: Control

func _ready() -> void:
	# Load trader data from registry if trader_id is set
	if trader_id != "" and trader_data == null:
		var registry = TraderRegistry.get_instance()
		trader_data = registry.get_trader_data(trader_id)
	
	body_entered.connect(func(body) -> void:
		if body is FILE_PATH.PLAYER:
			# load ui to trade
			player = body
			print_debug("player can trade")
			if player:
				load_shop_ui()
	)

	body_exited.connect(func(_body) -> void:
		player = null
		unload_shop_ui()
	)

	#add_child(Utility.add_timer_with_callable(func(): ui.get_node("HBoxContainer/PriceLabel").text = str(Flux.stable(item_1)), 2.0)) # why?
	# issues:
	# timer has to stop when player is trading? or player can reserve certain prices?
	# think about how to get item at the price

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("interact") and player != null:
		print_debug("player wants to trade")
		load_shop_ui()
	
func load_shop_ui() -> void:
	if not ui:
		return
	
	if ui.visible:
		return

	var sfx = Utility.create_sfx_player(FILE_PATH.SFX_WHOOSH)
	add_child(sfx)
	sfx.name = "sfx_whoosh"
	sfx.volume_db = -10.0
	sfx.play()

	ui.visible = true

func unload_shop_ui() -> void:
	if not ui:
		print_debug("No Shop UI found")
		return

	if has_node("sfx_whoosh"):
		var sfx = $sfx_whoosh as AudioStreamPlayer
		if sfx:
			sfx.stream = FILE_PATH.SFX_WHOOSH_REVERSE
			sfx.play()
			sfx.finished.connect(func() -> void:
				sfx.queue_free()
			)
		ui.visible = false
