extends Area2D

func _ready() -> void:
	body_entered.connect(func(body: Node) -> void:
		if body is FILE_PATH.PLAYER:
			print_debug("player entered")
			var ui = get_tree().get_first_node_in_group("ui")
			ui.end_screen.show()
			print_debug("end screen found")
			var audio = Utility.create_sfx_player(FILE_PATH.SFX_LEVEL_COMPLETE)
			add_child(audio)
			audio.volume_db = -10.0
			audio.play()
	)
