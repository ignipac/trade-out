extends StaticBody2D

@export var interact_area: Area2D

func _ready() -> void:
	if interact_area:
		interact_area.body_entered.connect(func(body: Node) -> void:
			if body is FILE_PATH.PLAYER:
				body.in_interactable_area.emit(self)
		)

		interact_area.body_exited.connect(func(body: Node) -> void:
			if body is FILE_PATH.PLAYER:
				body.in_interactable_area.emit(null)
		)

func destroy() -> void:
	var audio = Utility.create_sfx_player(FILE_PATH.SFX_DOOR_OPEN)
	add_child(audio)
	audio.volume_db = -10.0
	get_tree().create_timer(0.4).timeout.connect(func() -> void:
		audio.play()
		sliding_door_anim()
	)
	
func sliding_door_anim() -> void:
	var sprite = $Sprite2D
	var tween = create_tween()
	tween.tween_property(sprite, "scale:x", 0, 0.2)
	tween.set_ease(Tween.EASE_OUT)
	tween.finished.connect(queue_free.call_deferred)
