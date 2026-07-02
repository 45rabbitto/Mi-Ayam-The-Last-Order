extends Node3D

@export var hp_off_mesh: MeshInstance3D
@export var hp_on_mesh: MeshInstance3D

var hp_found := false
var charger_found := false
var hp_charged := false


func _ready():

	print("LEVEL READY")

	# ==========================================
	# OBJECTIVE
	# ==========================================

	ObjectiveManager.reset()

	ObjectiveManager.add_objective("Ambil Charger")
	ObjectiveManager.add_objective("Ambil HP")
	ObjectiveManager.add_objective("Nyalakan HP")

	ObjectiveManager.start()

	print("Current Objective =", ObjectiveManager.get_current_objective())

func _connect_interactables():

	var objects = get_tree().get_nodes_in_group("interactable")

	for obj in objects:

		if obj.interacted.is_connected(on_item_collected):
			continue

		obj.interacted.connect(on_item_collected)
	# ==========================================
	# HP MODEL
	# ==========================================

	if hp_off_mesh:
		hp_off_mesh.visible = true

	if hp_on_mesh:
		hp_on_mesh.visible = false

# ==========================================================
# DIPANGGIL SAAT ITEM BERHASIL DIAMBIL
# ==========================================================

func on_item_collected(item_id:String):

	match item_id:

		"charger":

			charger_found = true

			Global.show_notification("Charger ditemukan")

			ObjectiveManager.complete_if_match("charger")

			if hp_found:
				Global.show_dialog("Sekarang nyalakan HP.")

		"phone":

			hp_found = true

			Global.show_notification("HP ditemukan")

			ObjectiveManager.complete_if_match("hp")

			if charger_found:
				Global.show_dialog("Sekarang nyalakan HP.")


# ==========================================================
# MENYALAKAN HP
# ==========================================================

func charge_hp():

	if hp_charged:
		return

	if !InventoryManager.has_item("phone"):
		return

	if !InventoryManager.has_item("charger"):
		return

	hp_charged = true

	InventoryManager.remove_item("phone")
	InventoryManager.remove_item("charger")

	if hp_off_mesh:
		hp_off_mesh.visible = false

	if hp_on_mesh:
		hp_on_mesh.visible = true

	ObjectiveManager.complete_if_match("nyalakan")

	AudioManager.play_voice_key("missed_call", 1)

	Global.show_notification("HP berhasil dinyalakan!")

	await get_tree().create_timer(1.5).timeout

	Global.show_dialog(
		"Missed call banyak banget... siapa ya? Nanti saja dicek."
	)

	await get_tree().create_timer(3.0).timeout

	level_complete()


# ==========================================================
# CHAPTER SELESAI
# ==========================================================

func level_complete():

	Global.show_notification("Chapter 1 selesai!")

	await get_tree().create_timer(2.0).timeout

	get_tree().change_scene_to_file(
		"res://scenes/level/level_02.tscn"
	)
