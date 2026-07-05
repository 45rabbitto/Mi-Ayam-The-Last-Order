extends Node

# ==========================================================
# REFERENCES
# ==========================================================

@onready var raycast: RayCast3D = $"../Head/Camera3D/RayCast3D"

# ==========================================================
# STATE
# ==========================================================

var current_object: Interactable = null
var locked_object: Interactable = null

# ==========================================================
# PROCESS
# ==========================================================

func _process(_delta: float) -> void:
	check_object()

# ==========================================================
# DETECT OBJECT
# ==========================================================

func check_object() -> void:

	raycast.force_raycast_update()

	var new_object: Interactable = null

	if raycast.is_colliding():

		var collider = raycast.get_collider()

		if collider is Interactable:
			new_object = collider

	# Saat sedang interact jangan ganti object
	if locked_object == null:
		_set_current_object(new_object)

# ==========================================================
# CHANGE CURRENT OBJECT
# ==========================================================

func _set_current_object(new_object: Interactable) -> void:

	# Tidak berubah
	if new_object == current_object:
		return

	# Hilangkan highlight object lama
	if is_instance_valid(current_object):
		current_object.hide_highlight()

	current_object = new_object

	# Object baru
	if is_instance_valid(current_object):

		current_object.show_highlight()

		UiManager.show_hint(
			current_object.get_prompt()
		)

	# Tidak melihat object
	else:

		UiManager.hide_hint()

# ==========================================================
# INTERACT
# ==========================================================

func try_interact() -> void:

	if !is_instance_valid(current_object):
		return

	# Lock object agar tidak berubah saat interact
	locked_object = current_object

	current_object.interact()

	# Object pickup kemungkinan queue_free()
	locked_object = null
	current_object = null

	UiManager.hide_hint()

	# Update ulang raycast
	check_object()

# ==========================================================
# CLEAR
# ==========================================================

func clear_current_object() -> void:

	if is_instance_valid(current_object):
		current_object.hide_highlight()

	current_object = null

	UiManager.hide_hint()
