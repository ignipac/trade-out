extends Area2D

func _ready() -> void:
	body_entered.connect(func(body: Node) -> void:
		if body is Access.PLAYER:
			print_debug("player entered")
			var ui = get_tree().get_first_node_in_group("ui")
			ui.end_screen.show()
			print_debug("end screen found")
	)
