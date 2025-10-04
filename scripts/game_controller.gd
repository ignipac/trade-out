extends Node2D

const MAX_KEYS = 1

@onready var player: FILE_PATH.PLAYER = get_tree().get_first_node_in_group("player")
@onready var door: FILE_PATH.DOOR = $Door

func _ready() -> void:
	player.found_key.connect(func() -> void:
		if player.key_count == MAX_KEYS:
			print_debug("remove door")
			door.destroy()
)
