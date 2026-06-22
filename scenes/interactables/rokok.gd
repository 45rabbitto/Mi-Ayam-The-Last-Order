extends StaticBody3D

func get_prompt() -> String:
	return "Periksa Rokok"

func interact(player):

	print("Rokok diperiksa")

	var controller = get_tree().get_first_node_in_group("level01")

	if controller:
		controller.inspect_item("Rokok")
