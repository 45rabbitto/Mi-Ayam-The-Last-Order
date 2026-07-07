extends Panel

func _gui_input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:

			var item = get_meta("item_id", "")

			if item == "":
				return

			match item:

				"phone":
					print("HP diklik")

				"charger":
					print("Charger diklik")
