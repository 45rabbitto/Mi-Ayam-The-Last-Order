extends Node3D

@export var item_name := "kunci"

func get_interaction_text():
	return "Ambil " + item_name

func interact():

	InventoryManager.add_item(item_name)

	Hud.show_notification(
		"Kamu mendapatkan " + item_name
	)

	queue_free()
