extends Button

func _pressed():

	var manager = get_tree().get_first_node_in_group(
		"interaction_manager"
	)

	if manager:

		manager.try_interact()
