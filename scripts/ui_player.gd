extends Control

@onready var inv_container := $Inv_Container
@onready var bal_label := %BalLabel
@onready var tar_label := %TarLabel

func add_inventory_item(item: String) -> Node:
	var item_scene = load(FILE_PATH.UI_INV_ITEM)
	var item_instance = item_scene.instantiate()
	inv_container.add_child(item_instance)
	item_instance.get_child(0).text = item
	return item_instance.get_child(1)

func update_inventory_item(item: String) -> Node:
	for child in inv_container.get_children():
		if child.get_child(0).text == item:
			return child.get_child(1)

	return null
