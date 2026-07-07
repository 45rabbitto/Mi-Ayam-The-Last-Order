extends Control

@onready var slots = [
	$slot1,
	$slot2,
	$slot3,
	$slot4,
	$slot5
]

func _ready():

	print("Inventory UI Ready")
	print(InventoryManager.get_items())

	InventoryManager.inventory_changed.connect(update_inventory)

	update_inventory(InventoryManager.get_items())

func update_inventory(items:Array[String]):

	# Kosongkan semua slot
	for slot in slots:

		var icon = slot.get_node("TextureRect")

		icon.texture = null
		icon.visible = false

		slot.set_meta("item_id", "")

	# Isi slot sesuai inventory
	for i in range(min(items.size(), slots.size())):

		var slot = slots[i]
		var icon = slot.get_node("TextureRect")

		slot.set_meta("item_id", items[i])

		icon.texture = load("res://assets/ui/items/%s.png" % items[i])
		icon.visible = true
