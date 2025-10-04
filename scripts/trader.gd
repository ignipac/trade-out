extends Area2D

@export var canvas: CanvasLayer

var maybe_load_dynamically: String = "res://ui/ui_shop.tscn" 
var player = null

@onready var ui_shop := $UI/UIShop

func _ready() -> void:
	Utility.add_action_for_key("trade", KEY_E)

	body_entered.connect(func(body) -> void:
		if body is FILE_PATH.PLAYER:
			# load ui to trade
			player = body
			print_debug("player can trade")
	)

	body_exited.connect(func(_body) -> void:
		player = null
		ui_shop.visible = false
	)

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("trade") and player != null:
		print_debug("player wants to trade")
		ui_shop.visible = true
