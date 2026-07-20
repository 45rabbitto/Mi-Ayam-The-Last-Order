extends Control


# ==========================================================
# SLOT INVENTORY
# ==========================================================

@onready var slots: Array[Control] = [

	$slot1,
	$slot2,
	$slot3,
	$slot4,
	$slot5,
	$slot6,
	$slot7

]


# ==========================================================
# READY
# ==========================================================

func _ready() -> void:

	add_to_group("inventory_ui")

	print("================================")
	print("INVENTORY UI READY")
	print("CURRENT CHAPTER : ",
		GameManager.current_chapter
	)
	print("INVENTORY SAAT MASUK : ",
		InventoryManager.get_items()
	)
	print("JUMLAH ITEM : ",
		InventoryManager.get_item_count()
	)
	print("================================")


	# Connect signal inventory
	if !InventoryManager.inventory_changed.is_connected(
		update_inventory
	):

		InventoryManager.inventory_changed.connect(
			update_inventory
		)


	# Tampilkan inventory saat awal
	update_inventory(
		InventoryManager.get_items()
	)


	# Connect klik slot
	_connect_slots()


# ==========================================================
# CONNECT MOUSE CLICK
# ==========================================================

func _connect_slots() -> void:

	for i in range(slots.size()):

		var index := i

		slots[i].gui_input.connect(
			func(event: InputEvent):

				if event is InputEventMouseButton:

					if event.button_index == MOUSE_BUTTON_LEFT \
					and event.pressed:

						use_slot(index)
		)


# ==========================================================
# UPDATE INVENTORY
# ==========================================================

func update_inventory(
	inventory_items: Array[String]
) -> void:

	print("UPDATE INVENTORY : ",
		inventory_items
	)


	# ======================================================
	# SUSUN ITEM
	# PHONE SELALU SLOT 1
	# CHARGER SELALU SLOT 2
	# ======================================================

	var display_items: Array[String] = []

	# PHONE
	if inventory_items.has("phone"):

		display_items.append("phone")


	# CHARGER
	if inventory_items.has("charger"):

		display_items.append("charger")


	# ITEM LAIN
	for item_id in inventory_items:

		if item_id != "phone" \
		and item_id != "charger":

			display_items.append(item_id)


	# ======================================================
	# KOSONGKAN SEMUA SLOT
	# ======================================================

	for slot in slots:

		var icon: TextureRect = slot.get_node_or_null(
			"TextureRect"
		)

		if icon:

			icon.texture = null
			icon.visible = false

		slot.set_meta(
			"item_id",
			""
		)

		slot.modulate = Color.WHITE


	# ======================================================
	# ISI SLOT
	# ======================================================

	for i in range(
		min(display_items.size(), slots.size())
	):

		var item_id: String = display_items[i]

		var slot: Control = slots[i]

		var icon: TextureRect = slot.get_node_or_null(
			"TextureRect"
		)

		if icon:

			var texture := InventoryManager.get_item_icon(
				item_id
			)

			if texture:

				icon.texture = texture
				icon.visible = true

			else:

				print(
					"ICON TIDAK DITEMUKAN : ",
					item_id
				)


		slot.set_meta(
			"item_id",
			item_id
		)

		print(
			"Slot ",
			i + 1,
			" = ",
			item_id
		)


	# ======================================================
	# SLOT SELALU PUTIH SAAT UPDATE INVENTORY
	# ======================================================

	for slot in slots:

		slot.modulate = Color.WHITE


# ==========================================================
# SELECT SLOT
# ==========================================================

func select_inventory_slot(index: int) -> void:

	for i in range(slots.size()):

		if i == index:

			slots[i].modulate = Color(
				1.0,
				1.0,
				0.4
			)

		else:

			slots[i].modulate = Color.WHITE


# ==========================================================
# KLIK MOUSE SLOT
# ==========================================================

func use_slot(index: int) -> void:

	if index < 0:

		return

	if index >= slots.size():

		return


	var item: String = slots[index].get_meta(
		"item_id",
		""
	)


	if item == "":

		return


	print("================================")
	print("SLOT DIKLIK")
	print("SLOT : ", index + 1)
	print("ITEM : ", item)
	print("================================")


	# Pilih slot
	InventoryManager.select_slot(index)


	# Gunakan item
	use_item(item)


# ==========================================================
# TOMBOL 1-5
# DIPANGGIL PLAYER CONTROLLER
# ==========================================================

func use_selected_slot() -> void:

	var index := InventoryManager.get_selected_slot()


	if index < 0:

		print("TIDAK ADA SLOT TERPILIH")

		return


	print("================================")
	print("USE SELECTED SLOT")
	print("SLOT : ", index + 1)
	print("================================")


	# PANGGIL LOGIKA YANG SAMA DENGAN KLIK MOUSE
	use_slot(index)


# ==========================================================
# USE ITEM
# ==========================================================
func use_item(item: String) -> void:

	print("USE ITEM : ", item)

	# ==================================================
	# CHAPTER 2
	# ==================================================

	if GameManager.current_chapter == 2:

		var level2 = get_tree().current_scene

		if level2.has_method("place_inventory_item"):

			level2.place_inventory_item(item)

		return


	# ==================================================
	# CHAPTER 1
	# ==================================================

	match item:

		"phone":

			print("HP DIKLIK")

			var phone_ui := get_tree().get_first_node_in_group(
				"phone_ui"
			)

			if phone_ui:

				phone_ui.open()


		"charger":

			print("CHARGER DIKLIK")

			if UiManager:

				UiManager.show_notification(
					"Charger dipilih"
				)


		_:

			print(
				item,
				" DIPILIH"
			)
