extends Node

@export var raycast: RayCast3D

var current_object: Node = null

func _process(_delta):

	if not raycast:
		return

	if raycast.is_colliding():

		var obj = raycast.get_collider()

		if obj != current_object:

			current_object = obj

			if obj.has_method("get_interaction_text"):
				Hud.show_interaction(
					obj.get_interaction_text()
				)

	else:

		current_object = null
		Hud.clear_interaction()

func interact():

	if current_object == null:
		return

	if current_object.has_method("interact"):
		current_object.interact()
