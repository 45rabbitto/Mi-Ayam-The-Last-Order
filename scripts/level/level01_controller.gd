extends Node3D

@export var hp_off_mesh: MeshInstance3D
@export var hp_on_mesh: MeshInstance3D

var hp_found := false
var charger_found := false
var hp_charged := false


func _ready():

	if hp_off_mesh:
		hp_off_mesh.visible = true

	if hp_on_mesh:
		hp_on_mesh.visible = false


func on_item_collected(item_id:String):

	match item_id:

		"hp_mati":
			hp_found = true

			Global.show_notification("HP ditemukan")

			if charger_found:
				Global.show_dialog("Sekarang gunakan charger ke HP.")

		"charger":
			charger_found = true

			Global.show_notification("Charger ditemukan")

			if hp_found:
				Global.show_dialog("Sekarang gunakan charger ke HP.")


func charge_hp():

	if hp_charged:
		return

	if !Global.has_item("hp_mati"):
		return

	if !Global.has_item("charger"):
		return

	hp_charged = true

	Global.remove_item("hp_mati")
	Global.remove_item("charger")

	if hp_off_mesh:
		hp_off_mesh.visible = false

	if hp_on_mesh:
		hp_on_mesh.visible = true

	AudioManager.play_voice_key("missed_call",1)

	Global.show_notification("HP berhasil dinyalakan!")

	await get_tree().create_timer(1.5).timeout

	Global.show_dialog(
		"Missed call banyak banget... siapa ya? Nanti aja lah."
	)

	await get_tree().create_timer(3)

	level_complete()


func level_complete():

	Global.show_notification("Chapter 1 selesai!")

	await get_tree().create_timer(2)

	get_tree().change_scene_to_file(
		"res://scenes/level/level_02.tscn"
	)
