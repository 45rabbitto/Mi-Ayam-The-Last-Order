extends StaticBody3D

func get_prompt() -> String:
	return "Ambil Charger"

func interact(player):

	var controller = get_tree().get_first_node_in_group("level01")

	if controller:
		controller.use_charger()
