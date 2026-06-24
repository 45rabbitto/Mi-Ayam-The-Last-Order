extends Node3D

@export var interaction_text := "Interact"

func interact():

	print(name, " diperiksa")

	var controller = get_tree().get_first_node_in_group(
		"level_controller"
	)

	if controller:

		controller.clue_inspected(name)
