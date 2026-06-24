extends Node

signal inventory_changed

const MAX_SLOT := 8

var items: Array[InventoryItem] = []

func add_item(item: InventoryItem) -> bool:

	if items.size() >= MAX_SLOT:
		print("Inventory penuh!")
		return false

	items.append(item)

	print("Item ditambahkan: ", item.item_name)

	inventory_changed.emit()

	return true

func remove_item(item: InventoryItem):

	if item in items:

		items.erase(item)

		inventory_changed.emit()

func has_item(item_name: String) -> bool:

	for item in items:

		if item.item_name == item_name:
			return true

	return false

func get_item(item_name: String):

	for item in items:

		if item.item_name == item_name:
			return item

	return null

func clear_inventory():

	items.clear()

	inventory_changed.emit()
