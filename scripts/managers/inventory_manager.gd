extends Node

signal inventory_changed(items: Array[String])

# ==========================================================
# ITEM DATABASE
# ==========================================================

const ITEM_DATABASE := {

	"charger": {
		"name": "Phone Charger",
		"model": preload("res://assets/3d/phone_charger_low_poly.glb")
	},

	"phone": {
		"name": "Phone",
		"model": preload("res://assets/3d/cell_phone.glb")
	}

}

# ==========================================================
# INVENTORY
# ==========================================================

var items: Array[String] = []

# ==========================================================
# ADD ITEM
# ==========================================================

func add_item(item_id: String) -> bool:

	item_id = item_id.strip_edges().to_lower()

	if item_id.is_empty():
		return false

	if has_item(item_id):
		return false

	if !ITEM_DATABASE.has(item_id):
		push_warning("Unknown item : " + item_id)
		return false

	items.append(item_id)

	_emit_inventory_changed()

	return true

# ==========================================================
# REMOVE ITEM
# ==========================================================

func remove_item(item_id: String) -> bool:

	item_id = item_id.to_lower()

	if !has_item(item_id):
		return false

	items.erase(item_id)

	_emit_inventory_changed()

	return true

# ==========================================================
# CLEAR
# ==========================================================

func clear_inventory() -> void:

	items.clear()

	_emit_inventory_changed()

# ==========================================================
# CHECK
# ==========================================================

func has_item(item_id: String) -> bool:

	return item_id.to_lower() in items

# ==========================================================
# GET INVENTORY
# ==========================================================

func get_items() -> Array[String]:

	return items.duplicate()

func get_item_count() -> int:

	return items.size()

# ==========================================================
# ITEM DATA
# ==========================================================

func has_item_data(item_id: String) -> bool:

	return ITEM_DATABASE.has(item_id)

func get_item_data(item_id: String) -> Dictionary:

	return ITEM_DATABASE.get(item_id, {})

func get_item_name(item_id: String) -> String:

	if !ITEM_DATABASE.has(item_id):
		return item_id

	return ITEM_DATABASE[item_id]["name"]

func get_item_model(item_id: String):

	if !ITEM_DATABASE.has(item_id):
		return null

	return ITEM_DATABASE[item_id]["model"]

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

func load_save_data(data: Dictionary) -> void:

	items.clear()

	if data.has("items"):
		items.assign(data["items"])

	_emit_inventory_changed()

# ==========================================================
# SIGNAL
# ==========================================================

func _emit_inventory_changed() -> void:

	inventory_changed.emit(items.duplicate())
