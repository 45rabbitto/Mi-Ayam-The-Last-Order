extends Node


# ==========================================================
# SAVE CONFIG
# ==========================================================

const SAVE_PATH := "user://savegame.json"


# ==========================================================
# CHECK SAVE
# ==========================================================

func has_save() -> bool:

	return FileAccess.file_exists(
		SAVE_PATH
	)


# ==========================================================
# SAVE GAME
# ==========================================================

func save_game() -> void:

	var current_scene := get_tree().current_scene

	if current_scene == null:

		print("SAVE GAGAL : CURRENT SCENE NULL")

		return


	var save_data := {

		# ------------------------------------------
		# SCENE
		# ------------------------------------------

		"scene_path":
			current_scene.scene_file_path,


		# ------------------------------------------
		# LEVEL
		# ------------------------------------------

		"level": {

			"current_level":
				LevelManager.current_level,

			"current_checkpoint":
				LevelManager.current_checkpoint

		},


		# ------------------------------------------
		# GAME MANAGER
		# ------------------------------------------

		"game": {

			"raka_condition":
				GameManager.raka_condition,

			"current_chapter":
				GameManager.current_chapter,

			"is_game_completed":
				GameManager.is_game_completed,


			# CHAPTER 1

			"inspected_objects":
				GameManager.inspected_objects,

			"phone_taken":
				GameManager.phone_taken,

			"charger_found":
				GameManager.charger_found,

			"phone_charged":
				GameManager.phone_charged,

			"chapter1_completed":
				GameManager.chapter1_completed,


			# CHAPTER 2

			"chapter2_completed":
				GameManager.chapter2_completed,

			"chapter2_fail_count":
				GameManager.chapter2_fail_count,

			"object_positions":
				GameManager.object_positions,


			# CHAPTER 3

			"skripsi_done":
				GameManager.skripsi_done,

			"coffee_done":
				GameManager.coffee_done,

			"mabar_done":
				GameManager.mabar_done,

			"order_prompt":
				GameManager.order_prompt,

			"chapter3_completed":
				GameManager.chapter3_completed,

			"chapter3_selected_item":
				GameManager.chapter3_selected_item,


			# CHAPTER 4

			"food_app_opened":
				GameManager.food_app_opened,

			"spam_click_count":
				GameManager.spam_click_count,

			"hold_confirm_done":
				GameManager.hold_confirm_done,

			"order_success":
				GameManager.order_success,

			"chapter4_completed":
				GameManager.chapter4_completed

		},


		# ------------------------------------------
		# INVENTORY
		# ------------------------------------------

		"inventory":
			InventoryManager.get_save_data()

	}


	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)


	if file == null:

		print("SAVE GAGAL : FILE TIDAK BISA DIBUKA")

		return


	file.store_string(
		JSON.stringify(save_data)
	)

	file.close()


	print("================================")
	print("SAVE BERHASIL")
	print("SCENE : ", current_scene.scene_file_path)
	print("CHAPTER : ", GameManager.current_chapter)
	print("INVENTORY : ", InventoryManager.get_items())
	print("================================")


# ==========================================================
# LOAD GAME
# ==========================================================

func load_game() -> void:

	if not has_save():

		print("LOAD GAGAL : SAVE TIDAK DITEMUKAN")

		return


	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.READ
	)


	if file == null:

		print("LOAD GAGAL : FILE TIDAK BISA DIBUKA")

		return


	var content := file.get_as_text()

	file.close()


	var data = JSON.parse_string(content)


	if data == null:

		print("LOAD GAGAL : DATA SAVE RUSAK")

		return


	var scene_path: String = data.get(
		"scene_path",
		""
	)


	if scene_path.is_empty():

		print("LOAD GAGAL : SCENE PATH KOSONG")

		return


	if not ResourceLoader.exists(scene_path):

		print(
			"LOAD GAGAL : SCENE TIDAK DITEMUKAN ",
			scene_path
		)

		return


	# ==========================================
	# RESTORE DATA SEBELUM PINDAH SCENE
	# ==========================================

	_restore_game_data(data)


	# ==========================================
	# PINDAH KE SCENE TERAKHIR
	# ==========================================

	print("================================")
	print("LOAD GAME")
	print("SCENE : ", scene_path)
	print("================================")


	get_tree().change_scene_to_file(
		scene_path
	)


	# ==========================================
	# RESTORE ULANG SETELAH SCENE READY
	# ==========================================

	await get_tree().process_frame
	await get_tree().process_frame


	_restore_game_data(data)


	print("================================")
	print("LOAD BERHASIL")
	print("CHAPTER : ", GameManager.current_chapter)
	print("INVENTORY : ", InventoryManager.get_items())
	print("================================")


# ==========================================================
# RESTORE DATA
# ==========================================================

func _restore_game_data(data: Dictionary) -> void:


	# ======================================================
	# LEVEL
	# ======================================================

	var level_data: Dictionary = data.get(
		"level",
		{}
	)


	LevelManager.current_level = level_data.get(
		"current_level",
		1
	)


	LevelManager.current_checkpoint = level_data.get(
		"current_checkpoint",
		0
	)


	# ======================================================
	# GAME MANAGER
	# ======================================================

	var game_data: Dictionary = data.get(
		"game",
		{}
	)


	GameManager.raka_condition = game_data.get(
		"raka_condition",
		100
	)


	GameManager.current_chapter = game_data.get(
		"current_chapter",
		1
	)


	GameManager.is_game_completed = game_data.get(
		"is_game_completed",
		false
	)


	# ======================================================
	# CHAPTER 1
	# ======================================================

	GameManager.inspected_objects = game_data.get(
		"inspected_objects",
		[]
	)


	GameManager.phone_taken = game_data.get(
		"phone_taken",
		false
	)


	GameManager.charger_found = game_data.get(
		"charger_found",
		false
	)


	GameManager.phone_charged = game_data.get(
		"phone_charged",
		false
	)


	GameManager.chapter1_completed = game_data.get(
		"chapter1_completed",
		false
	)


	# ======================================================
	# CHAPTER 2
	# ======================================================

	GameManager.chapter2_completed = game_data.get(
		"chapter2_completed",
		false
	)


	GameManager.chapter2_fail_count = game_data.get(
		"chapter2_fail_count",
		0
	)


	GameManager.object_positions = game_data.get(
		"object_positions",
		{
			"phone": false,
			"headset": false,
			"soda": false,
			"rokok": false,
			"charger": false
		}
	)


	# ======================================================
	# CHAPTER 3
	# ======================================================

	GameManager.skripsi_done = game_data.get(
		"skripsi_done",
		false
	)


	GameManager.coffee_done = game_data.get(
		"coffee_done",
		false
	)


	GameManager.mabar_done = game_data.get(
		"mabar_done",
		false
	)


	GameManager.order_prompt = game_data.get(
		"order_prompt",
		false
	)


	GameManager.chapter3_completed = game_data.get(
		"chapter3_completed",
		false
	)


	GameManager.chapter3_selected_item = game_data.get(
		"chapter3_selected_item",
		""
	)


	# ======================================================
	# CHAPTER 4
	# ======================================================

	GameManager.food_app_opened = game_data.get(
		"food_app_opened",
		false
	)


	GameManager.spam_click_count = game_data.get(
		"spam_click_count",
		0
	)


	GameManager.hold_confirm_done = game_data.get(
		"hold_confirm_done",
		false
	)


	GameManager.order_success = game_data.get(
		"order_success",
		false
	)


	GameManager.chapter4_completed = game_data.get(
		"chapter4_completed",
		false
	)


	# ======================================================
	# INVENTORY
	# ======================================================

	InventoryManager.load_save_data(
		data.get(
			"inventory",
			{}
		)
	)


	# ======================================================
	# UPDATE UI / SIGNAL
	# ======================================================

	GameManager.condition_changed.emit(
		GameManager.raka_condition
	)


	GameManager.chapter_changed.emit(
		GameManager.current_chapter
	)


# ==========================================================
# DELETE SAVE
# ==========================================================

func reset_save() -> void:

	if has_save():

		DirAccess.remove_absolute(
			SAVE_PATH
		)

		print("SAVE DIHAPUS")
