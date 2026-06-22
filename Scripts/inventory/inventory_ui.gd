extends CanvasLayer

@onready var item_list: Label = $Panel/VBoxContainer/ItemList

var visible_state: bool = false

func _ready():
	add_to_group("inventory_ui")
	hide_inventory()
	refresh_inventory()

# =========================
# TOGGLE INVENTORY
# =========================
func toggle_inventory():
	visible_state = !visible_state
	visible = visible_state

	print("INVENTORY OPEN:", visible_state)

	refresh_inventory()

# =========================
# HIDE
# =========================
func hide_inventory():
	visible_state = false
	visible = false

# =========================
# SHOW
# =========================
func show_inventory():
	visible_state = true
	visible = true
	refresh_inventory()

# =========================
# REFRESH UI
# =========================
func refresh_inventory():

	if item_list == null:
		return

	if InventoryManager == null:
		print("InventoryManager NOT FOUND")
		return

	var items = InventoryManager.items

	var text := "INVENTORY\n\n"

	print("INVENTORY DATA:", items)
	print("INVENTORY SIZE:", items.size())
	print("INVENTORY:", items)

	if items.size() == 0:
		text += "- Empty"
	else:
		for i in items:
			text += "- " + format_item(str(i)) + "\n"

	item_list.text = text

# =========================
# FORMAT ITEM
# =========================
func format_item(item: String) -> String:

	match item:
		"charger":
			return "Charger 🔌"
		"hp":
			return "Handphone 📱"
		"kunci":
			return "Kunci 🔑"
		"foto":
			return "Foto 📷"
		"obat":
			return "Obat 💊"
		_:
			return item
