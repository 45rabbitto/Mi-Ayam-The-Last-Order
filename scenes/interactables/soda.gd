extends StaticBody3D

func get_prompt() -> String:
	return "Periksa Soda"

func interact(player):

	print("Soda diperiksa")

	var controller = get_tree().get_first_node_in_group("level01")

	if controller:
		controller.inspect_item("Soda")
