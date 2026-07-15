extends Node3D

var restored_object := 0
const TOTAL_OBJECT := 5

func _ready():

	print("=== LEVEL 2 READY ===")

	ObjectiveManager.reset()

	ObjectiveManager.add_objective("Cari tahu apa yang berubah")
	ObjectiveManager.add_objective("Kembalikan semua benda")
	ObjectiveManager.add_objective("Periksa Jam")
	ObjectiveManager.add_objective("Baca Pesan Beni")

	ObjectiveManager.start()

	AudioManager.play_bgm("phone")

	await get_tree().create_timer(1.0).timeout

	UiManager.show_dialog(
		"Kenapa posisi barang-barang ini berubah?"
	)

	AudioManager.play_voice_key("aneh", 2)
