extends Control

@onready var key_count_label: Label = $KeyCountLabel
@onready var end_screen: Panel = $EndScreen

func _ready() -> void:
	add_to_group("ui")
	var player: Access.PLAYER = get_tree().get_first_node_in_group("player")
	player.found_key.connect(on_player_key_pickup.bind(player))

	$EndScreen/Again.pressed.connect(func() -> void:
		get_tree().reload_current_scene()
	)

func on_player_key_pickup(player):
	player.key_count += 1
	key_count_label.text = "{0} / {1} Keys".format([player.key_count, owner.MAX_KEYS])
