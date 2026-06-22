extends Node

var items: Array[String] = []

const SAVE_PATH := "user://inventory_save.json"

func _ready():
	load_inventory()

func add_item(item_name: String):

	items.append(item_name)

	print("Item added:", item_name)
	print("ITEMS:", items)

	save_inventory()
	notify_ui()

func remove_item(item_name: String):

	if item_name in items:

		items.erase(item_name)

		save_inventory()
		notify_ui()

func has_item(item_name: String) -> bool:
	return item_name in items

func get_items() -> Array[String]:
	return items

func save_inventory():

	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	var data = {
		"items": items
	}

	file.store_string(JSON.stringify(data))

func load_inventory():

	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.READ
	)

	var data = JSON.parse_string(
		file.get_as_text()
	)

	if data is Dictionary:
		items = data.get("items", [])

	notify_ui()

func notify_ui():

	var ui = get_tree().get_first_node_in_group(
		"inventory_ui"
	)

	if ui:
		ui.refresh_inventory()
