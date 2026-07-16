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

			if Global.current_level == 1:

				var phone_ui = get_tree().current_scene.get_node_or_null("PhoneUi")

				print("PhoneUI =", phone_ui)

				if phone_ui:
					print("Membuka Phone UI")
					phone_ui.open()
				else:
					print("PhoneUi TIDAK DITEMUKAN")

			elif Global.current_level == 2:

				var phone_notif = get_tree().current_scene.get_node_or_null("PhoneNotif")

				print("PhoneNotif =", phone_notif)

				if phone_notif:
					print("Membuka PhoneNotif")
					phone_notif.open()
				else:
					print("PhoneNotif TIDAK DITEMUKAN")
