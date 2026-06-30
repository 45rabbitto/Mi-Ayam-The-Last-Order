extends Node

signal inventory_changed(items: Array)

# ==========================================================
# INVENTORY DATA
# ==========================================================

var items: Array[String] = []

# ==========================================================
# ADD ITEM
# ==========================================================

func add_item(item_name: String) -> bool:

	item_name = item_name.strip_edges()

	if item_name.is_empty():
		return false

	# Jangan boleh item ganda
	if has_item(item_name):
		return false

	items.append(item_name)

	print("ADD ITEM -> ", item_name)

	_emit_inventory_changed()

	return true


# ==========================================================
# REMOVE ITEM
# ==========================================================

func remove_item(item_name: String) -> bool:

	if !has_item(item_name):
		return false

	items.erase(item_name)

	print("REMOVE ITEM -> ", item_name)

	_emit_inventory_changed()

	return true


# ==========================================================
# CHECK ITEM
# ==========================================================

func has_item(item_name: String) -> bool:
	return items.has(item_name)


# ==========================================================
# GET ITEMS
# ==========================================================

func get_items() -> Array[String]:
	return items.duplicate()


# ==========================================================
# ITEM COUNT
# ==========================================================

func get_item_count() -> int:
	return items.size()


# ==========================================================
# CLEAR INVENTORY
# ==========================================================

func clear_inventory():

	items.clear()

	_emit_inventory_changed()


# ==========================================================
# SAVE
# ==========================================================

func get_save_data() -> Dictionary:

	return {
		"items": items.duplicate()
	}


# ==========================================================
# LOAD
# ==========================================================

func load_save_data(data: Dictionary):

	items.clear()

	if data.has("items") and data["items"] is Array:
		items = data["items"].duplicate()

	_emit_inventory_changed()


# ==========================================================
# SIGNAL
# ==========================================================

func _emit_inventory_changed():

	inventory_changed.emit(items.duplicate())
