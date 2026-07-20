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
		
	print("=== LEVEL 1 READY DARI SCRIPT BARU ===")
	print("SCRIPT =", get_script().resource_path)
	
	Global.current_level = 1
	GameManager.current_chapter = 1
	LevelManager.current_level = 1
	
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

	var objects = get_tree().get_nodes_in_group("interactable")

	print("Found ", objects.size(), " interactable objects")

	for obj in objects:

		print("CONNECT :", obj.item_id)

		if !obj.interacted.is_connected(on_item_collected):

			obj.interacted.connect(on_item_collected)


# ==========================================================
# ITEM COLLECTED
# ==========================================================

func on_item_collected(item_id: String):

	print("LEVEL1 RECEIVED =", item_id)
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

			InventoryManager.add_item("charger")

			Global.show_notification("Charger ditemukan")

			ObjectiveManager.complete_current()

			print("OBJECTIVE SEKARANG =", ObjectiveManager.get_current_objective())


		# ==================================================
		# PHONE
		# ==================================================

		"phone":

			if hp_found:
				return

			hp_found = true

			print("PHONE DITEMUKAN")

			InventoryManager.add_item("phone")

			Global.show_notification("HP ditemukan")

			ObjectiveManager.complete_current()

			print("OBJECTIVE SEKARANG =", ObjectiveManager.get_current_objective())

			print("SESUDAH COMPLETE = ", ObjectiveManager.get_current_objective())

			print("OBJECTIVE SEKARANG = ", ObjectiveManager.get_current_objective())
			
			print("INVENTORY SEKARANG : ", InventoryManager.get_items())

			print("HP siap digunakan")
