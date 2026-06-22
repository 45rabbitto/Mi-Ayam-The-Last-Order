extends StaticBody3D

var inspected := false

func get_prompt() -> String:
	return "Periksa Headset"

func interact(player):

	if inspected:
		return

	inspected = true

	print("Headset diperiksa")

	var controller = get_tree().get_first_node_in_group("level01")

	if controller:
		controller.inspect_item("Headset")
