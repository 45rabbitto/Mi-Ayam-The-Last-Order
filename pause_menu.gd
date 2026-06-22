extends Control

func _input(event):

	if Input.is_action_just_pressed("pause"):

		visible = !visible

		get_tree().paused = visible

		if visible:
			Input.set_mouse_mode(
				Input.MOUSE_MODE_VISIBLE
			)
		else:
			Input.set_mouse_mode(
				Input.MOUSE_MODE_CAPTURED
			)
