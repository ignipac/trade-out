class_name Flux extends Node

## When item resource value is stable flux
static func stable(item) -> float:
	# Called every frame. 'delta' is the elapsed time since the previous frame.
	# Implement your game's stable flux logic here.
	var random_offset = randf_range(-0.05, 0.05)
	var new_price = item * random_offset * 100
	item += roundf(new_price) / 100.0
	return item