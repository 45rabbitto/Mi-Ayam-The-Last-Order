extends StaticBody3D

var inspected := false

func get_prompt() -> String:
	return "Periksa Poster"

func interact(player):

	if inspected:
		return

	inspected = true

	print("Poster diperiksa")

	var controller = get_tree().get_first_node_in_group("level01")

	if controller:
		controller.inspect_item("Poster")
