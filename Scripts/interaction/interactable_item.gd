extends StaticBody3D
class_name InteractableItem

@export var item_name: String = ""
@export_multiline var inspect_text: String = ""

func interact(player):

	# DEBUG (opsional)
	print("Picked:", item_name)

	# =========================
	# PHONE NOTIFICATION
	# =========================
	if item_name == "charger":
		PhoneNotif.push("Kamu mendapatkan Charger 🔌")
	
	elif item_name == "hp":
		PhoneNotif.push("Handphone ditemukan 📱")
	
	elif item_name == "kunci":
		PhoneNotif.push("Kamu mendapatkan Kunci 🔑")
	
	elif item_name == "foto":
		PhoneNotif.push("Foto lama ditemukan 📷")
	
	elif item_name == "obat":
		PhoneNotif.push("Obat dimasukkan ke inventory 💊")
	
	else:
		PhoneNotif.push("Item ditemukan: " + item_name)

	# hapus objek dari dunia
	queue_free()

func get_prompt():
	return "Pick up " + item_name
