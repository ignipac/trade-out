extends Control

@export var slide_duration: float = 0.5

@onready var initial_pos: Vector2 = global_position

func slide(final_pos: Vector2) -> void:
	var tween = create_tween()
	tween.tween_property(
		self, "global_position", final_pos, slide_duration
		).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
