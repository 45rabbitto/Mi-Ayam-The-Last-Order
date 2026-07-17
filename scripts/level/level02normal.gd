extends Node


var phone_notif_opened := false


func _ready():

	print("===== MASUK LEVEL2 NORMAL =====")
	print("Scene =", get_tree().current_scene.name)


	Global.current_level = 2


	ObjectiveManager.reset()

	ObjectiveManager.add_objective(
		"LANJUT CHAPTER 3"
	)

	ObjectiveManager.start()


	print("PLAY BGM PHONE")

	start_dialog()


# ==========================================================
# DIALOG
# ==========================================================

func start_dialog():

	AudioManager.play_voice_key(
		"sepi",
		2
	)

	await AudioManager.voice_finished


	AudioManager.play_voice_key(
		"sunyi",
		2
	)

	await AudioManager.voice_finished


	show_next_level_button()


# ==========================================================
# BUTTON NEXT LEVEL
# ==========================================================

func show_next_level_button():

	var btn = get_tree().current_scene.get_node_or_null(
		"Hud/level2ui/ButtonNextLevel3"
	)


	if btn:

		btn.show()

	else:

		print(
			"ButtonNextLevel3 tidak ditemukan"
		)


# ==========================================================
# OPEN PHONE NOTIF
# ==========================================================

func open_phone_notif():

	if phone_notif_opened:

		return


	var phone_notif = get_tree().current_scene.get_node_or_null(
		"Hud/PhoneNotif"
	)


	if phone_notif == null:

		print(
			"PhoneNotif tidak ditemukan"
		)

		return


	phone_notif.open()

	phone_notif_opened = true


	print(
		"PHONE NOTIF DIBUKA"
	)
