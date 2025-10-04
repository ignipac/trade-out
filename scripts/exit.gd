extends StaticBody2D

func destroy() -> void:
	var audio = Utility.create_sfx_player(FILE_PATH.SFX_DOOR_OPEN)
	add_child(audio)
	audio.volume_db = -10.0
	get_tree().create_timer(0.2).timeout.connect(func() -> void:
		audio.play()
		sliding_door_anim()
	)
	
func sliding_door_anim() -> void:
	var sprite = $Sprite2D
	var tween = create_tween()
	tween.tween_property(sprite, "scale:x", 0, 0.2)
	tween.set_ease(Tween.EASE_OUT)
	tween.finished.connect(queue_free.call_deferred)
