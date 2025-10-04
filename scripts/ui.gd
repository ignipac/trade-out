extends Control

@onready var key_count_label: Label = $KeyCountLabel
@onready var end_screen: Panel = $EndScreen

# Trade UI elements (will be created dynamically if not present)
var trade_prompt_label: Label
var message_label: Label
var message_timer: Timer

func _ready() -> void:
	add_to_group("ui")
	var player: FILE_PATH.PLAYER = get_tree().get_first_node_in_group("player")
	player.found_key.connect(on_player_key_pickup.bind(player))

	$EndScreen/Again.pressed.connect(func() -> void:
		get_tree().reload_current_scene()
	)
	
	# Setup trade UI elements
	setup_trade_ui()

func on_player_key_pickup(player):
	player.key_count += 1
	key_count_label.text = "{0} / {1} Keys".format([player.key_count, owner.MAX_KEYS])

func setup_trade_ui() -> void:
	# Create trade prompt label if it doesn't exist
	if not trade_prompt_label:
		trade_prompt_label = Label.new()
		trade_prompt_label.name = "TradePromptLabel"
		trade_prompt_label.text = ""
		trade_prompt_label.add_theme_color_override("font_color", Color.YELLOW)
		trade_prompt_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		trade_prompt_label.anchor_left = 0.5
		trade_prompt_label.anchor_right = 0.5
		trade_prompt_label.anchor_top = 0.7
		trade_prompt_label.anchor_bottom = 0.7
		trade_prompt_label.offset_left = -100
		trade_prompt_label.offset_right = 100
		trade_prompt_label.visible = false
		add_child(trade_prompt_label)
	
	# Create message label if it doesn't exist
	if not message_label:
		message_label = Label.new()
		message_label.name = "MessageLabel"
		message_label.text = ""
		message_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		message_label.anchor_left = 0.5
		message_label.anchor_right = 0.5
		message_label.anchor_top = 0.8
		message_label.anchor_bottom = 0.8
		message_label.offset_left = -150
		message_label.offset_right = 150
		message_label.visible = false
		add_child(message_label)
	
	# Create message timer if it doesn't exist
	if not message_timer:
		message_timer = Timer.new()
		message_timer.name = "MessageTimer"
		message_timer.wait_time = 3.0
		message_timer.one_shot = true
		message_timer.timeout.connect(hide_message)
		add_child(message_timer)

func show_prompt(text: String) -> void:
	if trade_prompt_label:
		trade_prompt_label.text = text
		trade_prompt_label.visible = true

func hide_prompt() -> void:
	if trade_prompt_label:
		trade_prompt_label.visible = false

func show_message(text: String, color: Color = Color.WHITE) -> void:
	if message_label:
		message_label.text = text
		message_label.add_theme_color_override("font_color", color)
		message_label.visible = true
		
		# Auto-hide after 3 seconds
		if message_timer:
			message_timer.start()

func hide_message() -> void:
	if message_label:
		message_label.visible = false
