extends Control

# ==========================================================
# SLOT INVENTORY
# ==========================================================

@onready var slots = [
	$slot1,
	$slot2,
	$slot3,
	$slot4,
	$slot5
]

# ==========================================================
# READY
# ==========================================================

func _ready():

	# agar bisa dipanggil dari PlayerController
	add_to_group("inventory_ui")

	if InventoryManager:

		if !InventoryManager.inventory_changed.is_connected(update_inventory):
			InventoryManager.inventory_changed.connect(update_inventory)

	update_inventory(
		InventoryManager.get_items()
	)

	_connect_slots()

# ==========================================================
# CONNECT SLOT CLICK
# ==========================================================

func _connect_slots():

	for i in range(slots.size()):

		var slot = slots[i]

		slot.gui_input.connect(

			func(event):

				if event is InputEventMouseButton \
				and event.button_index == MOUSE_BUTTON_LEFT \
				and event.pressed:

					use_slot(i)

		)

# ==========================================================
# UPDATE INVENTORY
# ==========================================================

func update_inventory(items:Array[String]):

	# Bersihkan semua slot
	for slot in slots:

		var icon:TextureRect = slot.get_node("TextureRect")

		icon.texture = null
		icon.visible = false

		slot.set_meta("item_id","")

		slot.modulate = Color.WHITE

	# Isi inventory
	for i in range(min(items.size(), slots.size())):

		var slot = slots[i]

		var icon:TextureRect = slot.get_node("TextureRect")

		slot.set_meta("item_id", items[i])

		icon.texture = InventoryManager.get_item_icon(items[i])
		icon.visible = true

	select_inventory_slot(
		InventoryManager.get_selected_slot()
	)

# ==========================================================
# HIGHLIGHT SLOT
# ==========================================================

func select_inventory_slot(index:int):

	for i in range(slots.size()):

		if i == index:
			slots[i].modulate = Color(1,1,0.4)
		else:
			slots[i].modulate = Color.WHITE

# ==========================================================
# DIPANGGIL SAAT KLIK SLOT
# ==========================================================

func use_slot(index:int):

	if index < 0 or index >= slots.size():
		return

	print("Slot diklik")

	var item:String = slots[index].get_meta("item_id","")

	if item == "":
		return

	print("Item =", item)

	InventoryManager.select_slot(index)

	match item:

		"phone":

			print("HP diklik")

			var phone_ui = get_tree().get_first_node_in_group("phone_ui")

			print("PhoneUI =", phone_ui)

			if phone_ui:

				print("Membuka Phone UI")

				phone_ui.open()

		"charger":

			print("Charger diklik")

			UiManager.show_notification("Charger dipilih")

		_:

			print(item, " digunakan")

# ==========================================================
# DIPANGGIL OLEH TOMBOL 1-5
# ==========================================================

func use_selected_slot():
	print("USE SELECTED SLOT")

	var index = InventoryManager.get_selected_slot()

	if index == -1:
		return

	use_slot(index)

# ==========================================================
# LOGIKA PENGGUNAAN ITEM
# ==========================================================

func use_item(item:String):

	match item:

		# ===========================
		# PHONE
		# ===========================

		"phone":

			if UiManager.phone_ui:
				UiManager.phone_ui.open()
		
		# ===========================
		# CHARGER
		# ===========================

		"charger":

			print("CHARGER USED")

			UiManager.show_notification("Charger dipilih")

			# Contoh:
			# LevelController.use_charger()

		# ===========================
		# DEFAULT
		# ===========================

		_:

			print(item, " digunakan")
