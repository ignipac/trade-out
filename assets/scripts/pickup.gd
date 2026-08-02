extends Area2D

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		get_tree().get_first_node_in_group("player").found_key.emit()
		destroy()

func destroy() -> void:
	var sfx = $AudioListener2D
	sfx.play()
	hide()
	sfx.finished.connect(queue_free)