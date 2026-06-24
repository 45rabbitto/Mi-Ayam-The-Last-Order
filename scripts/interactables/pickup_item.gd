extends Interactable

@export var item_name : String = ""

func interact():

	print("ITEM DIAMBIL :", item_name)

	Inventory.add_item(self)

	queue_free()
