extends CharacterBody2D

var key_count: int

@warning_ignore("unused_signal")
signal found_key

func _ready() -> void:
	add_to_group("player")

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var x_dir := (int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A)))
	var y_dir := (int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W)))

	var direction = Vector2(x_dir, y_dir).normalized()

	var viewport_rect := get_viewport_rect()
	position.x = clamp(position.x, 0, viewport_rect.size.x)
	position.y = clamp(position.y, 0, viewport_rect.size.y)

	velocity = direction * 64.0
	move_and_slide()

