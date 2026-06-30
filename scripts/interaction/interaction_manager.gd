extends Node

@onready var raycast = $"../Head/Camera3D/RayCast3D"

var current_object: Interactable = null
var locked_object: Interactable = null
var lose_timer: float = 0.0


func _process(_delta):
	check_object()


func check_object():

	raycast.force_raycast_update()

	var new_object: Interactable = null

	if raycast.is_colliding():
		var collider = raycast.get_collider()

		if collider is Interactable:
			new_object = collider
	if locked_object == null:
		_set_current_object(new_object)


func _set_current_object(new_object: Interactable):

	if new_object == current_object:
		return

	if new_object != null:
		lose_timer = 0.0

	if new_object == null:
		lose_timer += get_process_delta_time()
		if lose_timer < 0.15:
			return

	if is_instance_valid(current_object):
		current_object.hide_highlight()

	current_object = new_object

	if current_object == null:
		Global.hide_interaction_hint()
		return

	current_object.show_highlight()

	Global.show_interaction_hint("TEKAN E")


func try_interact():

	print("E ditekan")

	if current_object == null:
		print("Tidak ada objek")
		return

	# LOCK supaya tidak hilang saat frame ini
	locked_object = current_object

	current_object.interact()

	# unlock setelah selesai
	locked_object = null
