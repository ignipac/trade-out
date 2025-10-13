extends Control

func _ready() -> void:
	visible = false

@onready var buy_button := %BuyButton
@onready var sell_button := $Items/Item1/SellButton
@onready var error_label := $ErrorLabel