extends Node

@export var raycast: RayCast3D

var current_target = null

func _process(_delta):

	check_interaction()

# =====================================================
# DETECT OBJECT
# =====================================================

func check_interaction():

	if !raycast:
		return

	if !raycast.is_colliding():

		current_target = null

		if Hud:
			Hud.clear_interaction()

		return

	var collider = raycast.get_collider()

	if collider == null:

		current_target = null

		if Hud:
			Hud.clear_interaction()

		return

	if collider.has_method("interact"):

		current_target = collider

		if Hud:

			var text = "Interact"

			if collider.has_variable("interaction_name"):
				text = collider.interaction_name

			Hud.show_interaction(
				"[E] " + text
			)

	else:

		current_target = null

		if Hud:
			Hud.clear_interaction()

# =====================================================
# KEYBOARD
# =====================================================

func _input(event):

	if event.is_action_pressed("interact"):

		perform_interaction()

# =====================================================
# ANDROID BUTTON
# =====================================================

func interact_button_pressed():

	perform_interaction()

# =====================================================
# EXECUTE
# =====================================================

func perform_interaction():

	if current_target == null:
		return

	if current_target.has_method("interact"):

		current_target.interact()
