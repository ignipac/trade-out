extends Node2D

const MAX_KEYS = 1

@export var player: FILE_PATH.PLAYER
@export var door: FILE_PATH.DOOR

var checkbox_value = false

func _ready() -> void:
	if player:
		player.found_key.connect(func() -> void:
			if player.key_count == MAX_KEYS:
				print_debug("remove door")
				door.destroy()
)
