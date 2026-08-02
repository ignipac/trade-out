extends Control


func _ready():
	$Control/SwapButton.pressed.connect(_on_SwapButton_pressed)

	print(get_tree())

func _on_SwapButton_pressed():
	var item_1 = $Control/Item1.texture
	var item_2 = $Control/Item2.texture

	$Control/Item1.texture = item_2
	$Control/Item2.texture = item_1
