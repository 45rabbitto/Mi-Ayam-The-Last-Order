extends Node

signal inventory_changed

# =====================================
# INVENTORY DATA
# =====================================

var items: Array[String] = []

# =====================================
# ADD ITEM
# =====================================

func add_item(item_name: String):

	if item_name.is_empty():
		return

	items.append(item_name)

	print("ADD ITEM -> ", item_name)

	inventory_changed.emit()

# =====================================
# REMOVE ITEM
# =====================================

func remove_item(item_name: String):

	if items.has(item_name):

		items.erase(item_name)

		print("REMOVE ITEM -> ", item_name)

		inventory_changed.emit()

# =====================================
# CHECK ITEM
# =====================================

func has_item(item_name: String) -> bool:

	return items.has(item_name)

# =====================================
# GET ALL ITEMS
# =====================================

func get_items() -> Array[String]:

	return items.duplicate()

# =====================================
# CLEAR INVENTORY
# =====================================

func clear_inventory():

	items.clear()

	inventory_changed.emit()

# =====================================
# SAVE DATA
# =====================================

func get_save_data() -> Dictionary:

	return {
		"items": items
	}

# =====================================
# LOAD DATA
# =====================================

func load_save_data(data: Dictionary):

	if data.has("items"):

		items = data["items"]

		inventory_changed.emit()
