extends Node3D

var hp_found := false
var charger_found := false

func _ready():

	print("=== LEVEL 1 READY ===")

	ObjectiveManager.reset()

	# Tambahkan semua objective dari awal
	ObjectiveManager.add_objective("Jelajahi Kamar")
	ObjectiveManager.add_objective("Ambil Charger")
	ObjectiveManager.add_objective("Nyalakan HP")

	AudioManager.play_bgm("chapter1_room")

	ObjectiveManager.start()

	_connect_interactables()

	print("Current Objective =", ObjectiveManager.get_current_objective())

	# Jika ada voice opening
	# AudioManager.play_voice_key("opening", 1)


func _connect_interactables():

	var objects = get_tree().get_nodes_in_group("interactable")

	print("Found", objects.size(), "interactable objects")

	for obj in objects:

		if obj.interacted.is_connected(on_item_collected):
			continue

		obj.interacted.connect(on_item_collected)


func on_item_collected(item_id:String):

	match item_id:

		"phone":

			if hp_found:
				return

			hp_found = true

			Global.show_notification("HP ditemukan")

			# Selesaikan objective pertama
			ObjectiveManager.complete_current()

			print("Objective :", ObjectiveManager.get_current_objective())


		"charger":

			if charger_found:
				return

			charger_found = true

			Global.show_notification("Charger ditemukan")

			# Selesaikan objective kedua
			ObjectiveManager.complete_current()

			print("Objective :", ObjectiveManager.get_current_objective())


func level_complete():

	Global.show_notification("Chapter 1 selesai!")

	await get_tree().create_timer(2.0).timeout

	get_tree().change_scene_to_file(
		"res://scenes/level/level_02.tscn"
	)
