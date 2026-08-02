extends Node

# In project setting, enable "Emulate Touch From Mouse"

# func _input(event: InputEvent) -> void:
# 	# if event is InputEventScreenTouch:
# 	# 	print(event)
	
# 	if event is InputEventScreenDrag:
# 		print(event)

@export var joystick_radius: float = 100.0 # max distance the stick can move
var touch_start: Vector2
var direction: Vector2 = Vector2.ZERO
var dragging: bool = false

func _input(event):
	if event is InputEventScreenTouch:
		if event.pressed:
			touch_start = event.position
			dragging = true
		else:
			dragging = false
			direction = Vector2.ZERO # reset when touch ends

	elif event is InputEventScreenDrag and dragging:
		var delta = event.position - touch_start
		if delta.length() > joystick_radius:
			delta = delta.normalized() * joystick_radius
		direction = delta / joystick_radius # normalized movement vector
		# Optional: move the visual joystick here
		# joystick_node.position = touch_start + delta

func _process(delta):
	if direction != Vector2.ZERO:
		# Example: move a character
		get_parent().position += direction.normalized() * 200 * delta # 200 = speed
