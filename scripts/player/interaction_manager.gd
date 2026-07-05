extends Node

@onready var raycast = $"../Head/Camera3D/RayCast3D"

var current_object: Interactable = null


func _process(_delta):
	check_object()


func check_object():

	# Matikan highlight objek sebelumnya
	if current_object:
		current_object.hide_highlight()

	current_object = null

	# Tidak mengenai apa pun
	if !raycast.is_colliding():
		Global.hide_interaction_hint()
		return

	var collider = raycast.get_collider()

	if collider is Interactable:

		current_object = collider

		current_object.show_highlight()

		Global.show_interaction_hint("Tekan E untuk inspeksi")

	else:

		Global.hide_interaction_hint()


func try_interact():

	print("E ditekan")

	if current_object == null:
		print("Tidak ada objek")
		return

	print("Objek =", current_object.name)

	current_object.interact()
