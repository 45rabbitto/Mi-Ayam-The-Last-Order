extends Area3D

signal interacted

func interact():

	interacted.emit()

	var phone = get_tree().current_scene.get_node("PhoneGrab")

	if phone:
		phone.open()

	var controller = get_tree().current_scene.get_node_or_null("Level4Controller")

	if controller:
		controller.phone_opened()
