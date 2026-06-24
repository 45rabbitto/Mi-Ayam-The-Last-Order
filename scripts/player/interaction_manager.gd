extends Node

@onready var raycast = get_node_or_null("../Head/RayCast3D")

var current_target = null

func _process(delta):
	check_interaction()

func check_interaction():

	if raycast == null:
		return

	if raycast.is_colliding():

		var collider = raycast.get_collider()

		if collider:

			var parent = collider.get_parent()

			if parent is Interactable:

				current_target = parent
				show_ui()
				return

	current_target = null
	hide_ui()

func show_ui():

	var ui = get_tree().get_first_node_in_group("interaction_ui")

	if ui and current_target:
		ui.show_interaction(current_target.interaction_name)

func hide_ui():

	var ui = get_tree().get_first_node_in_group("interaction_ui")

	if ui:
		ui.hide_interaction()

func try_interact():

	if current_target:
		current_target.interact()
