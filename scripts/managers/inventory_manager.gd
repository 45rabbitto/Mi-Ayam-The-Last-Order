extends Node

signal inventory_changed(items: Array[String])

# ==========================================================
# ITEM DATABASE
# ==========================================================

const ITEM_DATABASE := {
	"charger": {
		"name": "Phone Charger",
		"icon": preload("res://scenes/ui/items/charger.png")
	},

	"phone": {
		"name": "Phone",
		"icon": preload("res://scenes/ui/items/phone.png")
	}
}

# ==========================================================
# INVENTORY
# ==========================================================

var items: Array[String] = []

# slot yang sedang dipilih
var selected_slot: int = -1

# ==========================================================
# ADD ITEM
# ==========================================================

func add_item(item_id:String) -> bool:

	item_id = item_id.strip_edges().to_lower()

	print("Mencoba menambah item :", item_id)

	if item_id.is_empty():
		return false

	if has_item(item_id):
		print("Item sudah ada")
		return false

	if !ITEM_DATABASE.has(item_id):
		push_warning("Unknown item : " + item_id)
		return false

	items.append(item_id)

	if selected_slot == -1:
		selected_slot = 0

	_emit_inventory_changed()

	print("Inventory :", items)

	return true


# ==========================================================
# REMOVE ITEM
# ==========================================================

func remove_item(item_id:String) -> bool:

	item_id = item_id.to_lower()

	if !has_item(item_id):
		return false

	var index := items.find(item_id)

	items.remove_at(index)

	if items.is_empty():
		selected_slot = -1

	elif selected_slot >= items.size():
		selected_slot = items.size() - 1

	_emit_inventory_changed()

	print("REMOVE :", item_id)

	return true


# ==========================================================
# CLEAR INVENTORY
# ==========================================================

func clear_inventory():

	items.clear()

	selected_slot = -1

	_emit_inventory_changed()


# ==========================================================
# CHECK ITEM
# ==========================================================

func has_item(item_id:String) -> bool:

	return items.has(item_id.to_lower())


# ==========================================================
# GET ITEMS
# ==========================================================

func get_items() -> Array[String]:

	return items.duplicate()


func get_item_count() -> int:

	return items.size()


# ==========================================================
# ITEM DATABASE
# ==========================================================

func has_item_data(item_id:String) -> bool:

	return ITEM_DATABASE.has(item_id)


func get_item_data(item_id:String) -> Dictionary:

	return ITEM_DATABASE.get(item_id, {})


func get_item_name(item_id:String) -> String:

	if !ITEM_DATABASE.has(item_id):
		return item_id

	return ITEM_DATABASE[item_id]["name"]


func get_item_icon(item_id:String) -> Texture2D:

	if !ITEM_DATABASE.has(item_id):
		return null

	return ITEM_DATABASE[item_id]["icon"]


# ==========================================================
# SLOT SELECTION
# ==========================================================

func select_slot(index:int):

	if index < 0:
		selected_slot = -1
		return

	if index >= items.size():
		return

	selected_slot = index

	print("Selected Slot :", selected_slot)
	print("Selected Item :", items[selected_slot])

	if UiManager:
		UiManager.select_inventory_slot(selected_slot)


func get_selected_slot() -> int:

	return selected_slot


func get_selected_item() -> String:

	if selected_slot < 0:
		return ""

	if selected_slot >= items.size():
		return ""

	return items[selected_slot]


# ==========================================================
# USE SELECTED ITEM
# Dipanggil oleh klik mouse maupun tombol 1-5
# ==========================================================

func use_selected_item():

	var item := get_selected_item()

	if item == "":
		return

	match item:

		"phone":

			UiManager.show_dialog("Nyalakan HP?")

		"charger":

			UiManager.show_notification("Charger dipilih")

		_:

			print(item, " digunakan")


# ==========================================================
# SAVE
# ==========================================================

func get_save_data() -> Dictionary:

	return {
		"items": items.duplicate(),
		"selected_slot": selected_slot
	}


# ==========================================================
# LOAD
# ==========================================================

func load_save_data(data:Dictionary):

	items.clear()

	if data.has("items"):
		items.assign(data["items"])

	selected_slot = data.get("selected_slot", -1)

	if selected_slot >= items.size():
		selected_slot = -1

	_emit_inventory_changed()


# ==========================================================
# SIGNAL
# ==========================================================

func _emit_inventory_changed():

	inventory_changed.emit(items.duplicate())

	if UiManager:

		UiManager.update_inventory(items)

		if selected_slot != -1:
			UiManager.select_inventory_slot(selected_slot)
