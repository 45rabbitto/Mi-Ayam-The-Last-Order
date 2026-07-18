extends Node3D


# ==========================================================
# STATE
# ==========================================================

var hp_found := false
var charger_found := false


# ==========================================================
# READY
# ==========================================================

func _ready():

	Global.current_level = 1
		
	print("=== LEVEL 1 READY ===")

	ObjectiveManager.reset()

	ObjectiveManager.add_objective(
		"Jelajahi Kamar"
	)

	ObjectiveManager.add_objective(
		"Ambil Charger"
	)

	ObjectiveManager.add_objective(
		"Nyalakan HP"
	)

	AudioManager.play_bgm("phone")

	ObjectiveManager.start()

	_connect_interactables()

	print(
		"Current Objective = ",
		ObjectiveManager.get_current_objective()
	)

	AudioManager.play_voice_key(
		"kamar_berat",
		1
	)


# ==========================================================
# CONNECT INTERACTABLE
# ==========================================================

func _connect_interactables():

	var objects = get_tree().get_nodes_in_group(
		"interactable"
	)

	print(
		"Found ",
		objects.size(),
		" interactable objects"
	)

	for obj in objects:

		if obj.interacted.is_connected(
			on_item_collected
		):

			continue

		obj.interacted.connect(
			on_item_collected
		)


# ==========================================================
# ITEM COLLECTED
# ==========================================================

func on_item_collected(item_id: String):

	print(
		"ITEM INTERACTED : ",
		item_id
	)

	match item_id:


		# ==================================================
		# CHARGER
		# ==================================================

		"charger":

			if charger_found:

				return

			charger_found = true

			print(
				"CHARGER DITEMUKAN"
			)

			InventoryManager.add_item(
				"charger"
			)

			Global.show_notification(
				"Charger ditemukan"
			)

			# Selesaikan objective Ambil Charger
			ObjectiveManager.complete_current()

			print(
				"INVENTORY SEKARANG : ",
				InventoryManager.get_items()
			)

			print(
				"OBJECTIVE SEKARANG : ",
				ObjectiveManager.get_current_objective()
			)


		# ==================================================
		# PHONE
		# ==================================================

		"phone":

			if hp_found:
				return

			if not charger_found:

				Global.show_notification(
					"HP itu belum bisa digunakan..."
				)

				return

			hp_found = true

			print("PHONE DITEMUKAN")

			InventoryManager.add_item("phone")

			Global.show_notification("HP ditemukan")

			# PINDAH KE OBJECTIVE BERIKUTNYA
			ObjectiveManager.complete_current()

			print("OBJECTIVE SEKARANG : ", ObjectiveManager.get_current_objective())

			print("INVENTORY SEKARANG : ", InventoryManager.get_items())

			print("HP siap digunakan")
