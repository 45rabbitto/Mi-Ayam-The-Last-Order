extends Area3D

func _ready():
	print("LAPTOP READY")
	add_to_group("interactable")

func get_prompt() -> String:
	return "Periksa Laptop"

func interact(player):

	print("=== LAPTOP INTERACT ===")

	var controllers = get_tree().get_nodes_in_group("level01_controller")

	if controllers.size() == 0:
		print("NO CONTROLLER FOUND")
		return

	var controller = controllers[0]

	print("Controller =", controller)

	print("Memanggil clue_inspected")

	controller.clue_inspected("Laptop")
