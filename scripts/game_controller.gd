extends Node2D

const MAX_KEYS = 1

@onready var player: Access.PLAYER = get_tree().get_first_node_in_group("player")
@onready var door: Access.DOOR = $Door

func _ready() -> void:
	player.found_key.connect(func() -> void:
		if player.key_count == MAX_KEYS:
			door.queue_free.call_deferred()
	)
