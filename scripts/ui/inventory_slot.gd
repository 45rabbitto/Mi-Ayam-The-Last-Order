extends Panel

func _gui_input(event):
	
	AudioManager.play_ui("inventory_open")

	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed:

		print("Slot diklik")

		var item = get_meta("item_id", "")
		print("Item =", item)

		if item == "":
			return

		if item == "phone":

			print("HP diklik")

			var phone_ui = get_tree().current_scene.get_node_or_null("PhoneUi")

			print("PhoneUI =", phone_ui)

			if phone_ui:
				print("Membuka Phone UI")
				phone_ui.open()
			else:
				print("PhoneUi TIDAK DITEMUKAN")

		elif item == "charger":
			print("Charger diklik")
