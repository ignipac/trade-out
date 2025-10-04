extends CharacterBody2D

var key_count: int
var is_using_touch: bool = false

@warning_ignore("unused_signal")
signal found_key

var input_touch := FILE_PATH.INPUT_TOUCH.new() # NOTE: rm & unique mobile input

func _ready() -> void:
	add_to_group("player")
	add_child(input_touch)

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	var x_dir := (int(Input.is_key_pressed(KEY_D)) - int(Input.is_key_pressed(KEY_A)))
	var y_dir := (int(Input.is_key_pressed(KEY_S)) - int(Input.is_key_pressed(KEY_W)))

	var direction = Vector2(x_dir, y_dir).normalized()

	velocity = direction * 200.0
	move_and_slide()