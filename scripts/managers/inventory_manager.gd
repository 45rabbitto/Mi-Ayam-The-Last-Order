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
	},

	"laptop": {
		"name": "Laptop",
		"icon": preload("res://scenes/ui/items/laptop.png")
	},

	"headset": {
		"name": "Headset",
		"icon": preload("res://scenes/ui/items/headset.png")
	},

	"rokok": {
		"name": "Rokok",
		"icon": preload("res://scenes/ui/items/rokok.png")
	},

	"poster": {
		"name": "Poster",
		"icon": preload("res://scenes/ui/items/poster.png")
	},

	"sendok": {
		"name": "Sendok",
		"icon": preload("res://scenes/ui/items/sendok.png")
	},

	"kopi_bubuk": {
		"name": "Kopi Bubuk",
		"icon": preload("res://scenes/ui/items/kopi_bubuk.jpeg")
	},

	"dispenser": {
		"name": "Dispenser",
		"icon": preload("res://scenes/ui/items/dispenser.png")
	}

}


# ==========================================================
# INVENTORY
# ==========================================================

var items: Array[String] = []

var selected_slot: int = -1


# ==========================================================
# ADD ITEM
# ==========================================================

func add_item(item_id: String) -> bool:

	item_id = item_id.strip_edges().to_lower()

	if item_id.is_empty():

		return false


	if has_item(item_id):

		return false


	if not ITEM_DATABASE.has(item_id):

		push_warning(
			"Unknown item : " + item_id
		)

		return false


	selected_slot = -1

	items.append(item_id)


	_emit_inventory_changed()


	print("ADD ITEM :", item_id)

	print("INVENTORY :", items)


	return true


# ==========================================================
# REMOVE ITEM
# ==========================================================

func remove_item(item_id: String) -> bool:

	item_id = item_id.strip_edges().to_lower()

	if not has_item(item_id):

		return false


	var index := items.find(item_id)

	items.erase(item_id)


	if items.is_empty():

		selected_slot = -1


	elif selected_slot >= items.size():

		selected_slot = items.size() - 1


	elif selected_slot == index:

		selected_slot = clamp(
			index,
			0,
			items.size() - 1
		)


	_emit_inventory_changed()


	return true


# ==========================================================
# CLEAR INVENTORY
# ==========================================================

func clear_inventory() -> void:

	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

	print("CLEAR INVENTORY DIPANGGIL")

	print("ITEM SEBELUM CLEAR : ", items)

	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!")


	items.clear()

	selected_slot = -1


	_emit_inventory_changed()


	print("INVENTORY CLEARED")


# ==========================================================
# CHECK ITEM
# ==========================================================

func has_item(item_id: String) -> bool:

	return items.has(
		item_id.strip_edges().to_lower()
	)


# ==========================================================
# GET ITEMS
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

	if not ITEM_DATABASE.has(item_id):

		return item_id


	return ITEM_DATABASE[item_id]["name"]


func get_item_icon(item_id: String) -> Texture2D:

	if not ITEM_DATABASE.has(item_id):

		return null


	return ITEM_DATABASE[item_id]["icon"]


# ==========================================================
# SELECT SLOT
# ==========================================================

func select_slot(index: int) -> void:

	if index < 0:

		selected_slot = -1

		_emit_selection_changed()

		return


	if index >= items.size():

		return


	selected_slot = index


	print(
		"Selected Slot : ",
		selected_slot
	)

	print(
		"Selected Item : ",
		items[selected_slot]
	)


	_emit_selection_changed()


# ==========================================================
# GET SELECTED ITEM
# ==========================================================

func get_selected_item() -> String:

	if selected_slot < 0:

		return ""


	if selected_slot >= items.size():

		return ""


	return items[selected_slot]


# ==========================================================
# GET SELECTED SLOT
# ==========================================================

func get_selected_slot() -> int:

	return selected_slot


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

func load_save_data(data: Dictionary) -> void:

	items.clear()


	var saved_items = data.get(
		"items",
		[]
	)


	# ======================================================
	# FIX Array -> Array[String]
	# ======================================================

	for item_id in saved_items:

		if item_id is String:

			var normalized_item: String = item_id.strip_edges().to_lower()


			if ITEM_DATABASE.has(normalized_item):

				if normalized_item not in items:

					items.append(normalized_item)


	selected_slot = data.get(
		"selected_slot",
		-1
	)


	if selected_slot < 0:

		selected_slot = -1


	elif selected_slot >= items.size():

		selected_slot = -1


	_emit_inventory_changed()


	print("================================")

	print("INVENTORY BERHASIL DI-LOAD")

	print("ITEM : ", items)

	print("SELECTED SLOT : ", selected_slot)

	print("================================")


# ==========================================================
# SIGNAL INVENTORY
# ==========================================================

func _emit_inventory_changed() -> void:

	inventory_changed.emit(
		items.duplicate()
	)


	if UiManager:

		UiManager.update_inventory(
			items
		)


	_emit_selection_changed()


# ==========================================================
# SIGNAL SELECTION
# ==========================================================

func _emit_selection_changed() -> void:

	if UiManager:

		UiManager.select_inventory_slot(
			selected_slot
		)
