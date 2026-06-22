extends Node3D
class_name Interactable

@export var interaction_name := "Interact"
@export var item_data: ItemData

func interact():

	if item_data:

		InventoryManager.add_item(
			item_data.item_name
		)

		print("Picked:", item_data.item_name)

		queue_free()
