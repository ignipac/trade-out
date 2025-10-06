extends Control

@onready var inv_container := $Inv_Container
@onready var bal_label := %BalLabel
@onready var tar_label := %TarLabel

func add_inventory_item(item: String) -> void:
	var item_scene = load(FILE_PATH.UI_INV_ITEM)
	var item_instance = item_scene.instantiate()
	inv_container.add_child(item_instance)
	item_instance.get_child(0).text = item
	item_instance.get_child(1).text = "x1"
