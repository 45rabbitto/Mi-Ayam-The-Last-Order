extends Node


# ==========================================================
# SCENE PATH
# ==========================================================

const LEVEL_1 := "res://scenes/level/level_1_room.tscn"
const LEVEL_2 := "res://scenes/level/level_2_glitch_room.tscn"
const LEVEL_3 := "res://scenes/level/level_3_flashback.tscn"
const LEVEL_4 := "res://scenes/level/level_4_order.tscn"
const LEVEL_5 := "res://scenes/level/level_5_ending.tscn"


# ==========================================================
# DATA
# ==========================================================

var current_level: int = 1
var current_checkpoint: int = 0


# ==========================================================
# LOAD LEVEL
# ==========================================================

func load_level(level: int) -> void:

	current_level = clamp(
		level,
		1,
		5
	)
	GameManager.current_chapter = current_level
	Global.current_level = current_level

	print(
		"===================="
	)

	print(
		"LOAD LEVEL : ",
		current_level
	)

	print(
		"GAME CHAPTER : ",
		GameManager.current_chapter
	)

	print(
		"====================")


	match current_level:

		1:

			get_tree().change_scene_to_file(
				LEVEL_1
			)


		2:

			get_tree().change_scene_to_file(
				LEVEL_2
			)


		3:

			get_tree().change_scene_to_file(
				LEVEL_3
			)


		4:

			get_tree().change_scene_to_file(
				LEVEL_4
			)


		5:

			get_tree().change_scene_to_file(
				LEVEL_5
			)


	call_deferred(
		"initialize_level"
	)


# ==========================================================
# NEXT LEVEL
# ==========================================================

func next_level() -> void:

	if current_level >= 5:

		print(
			"GAME FINISHED"
		)

		GameManager.is_game_completed = true

		GameManager.game_completed.emit()

		UiManager.show_notification(
			"Terima kasih telah bermain."
		)

		return


	GameManager.load_chapter(
		current_level + 1
	)


# ==========================================================
# PREVIOUS LEVEL
# ==========================================================

func previous_level() -> void:

	if current_level <= 1:

		return


	GameManager.load_chapter(
		current_level - 1
	)


# ==========================================================
# RESTART
# ==========================================================

func restart_level() -> void:

	print(
		"RESTART LEVEL : ",
		current_level
	)

	load_level(
		current_level
	)


# ==========================================================
# CHECKPOINT
# ==========================================================

func set_checkpoint(id: int) -> void:

	current_checkpoint = id

	print(
		"CHECKPOINT : ",
		id
	)


func load_checkpoint() -> void:

	print(
		"LOAD CHECKPOINT : ",
		current_checkpoint
	)

	load_level(
		current_level
	)


# ==========================================================
# INITIALIZE LEVEL
# ==========================================================

func initialize_level() -> void:

	match current_level:

		1:

			setup_level_1()


		2:

			setup_level_2()


		3:

			setup_level_3()


		4:

			setup_level_4()


		5:

			setup_level_5()


# ==========================================================
# LEVEL 1
# ==========================================================

func setup_level_1() -> void:

	ObjectiveManager.set_objective(
		"Periksa seluruh kamar"
	)

	UiManager.show_notification(
		"HP mati..."
	)

	await get_tree().create_timer(
		2.0
	).timeout

	UiManager.show_notification(
		"Cari tahu apa yang terjadi."
	)


# ==========================================================
# LEVEL 2
# ==========================================================

func setup_level_2() -> void:

	print(
		"================================"
	)

	print(
		"LEVEL 2 READY"
	)

	print(
		"================================"
	)

	print(
		"INVENTORY LEVEL 2 : ",
		InventoryManager.get_items()
	)

	ObjectiveManager.set_objective(
		"Kembalikan benda ke posisi awal"
	)

	UiManager.show_notification(
		"Kamar ini terasa berbeda..."
	)

	await get_tree().create_timer(
		2.0
	).timeout

	UiManager.show_notification(
		"Ingat posisi semua benda."
	)


# ==========================================================
# LEVEL 3
# ==========================================================

func setup_level_3() -> void:

	ObjectiveManager.set_objective(
		"Selesaikan rutinitas malam"
	)

	UiManager.show_notification(
		"Ingat kembali malam terakhir..."
	)

	await get_tree().create_timer(
		2.0
	).timeout

	UiManager.show_notification(
		"Selesaikan semuanya sebelum terlambat."
	)


# ==========================================================
# LEVEL 4
# ==========================================================

func setup_level_4() -> void:

	ObjectiveManager.set_objective(
		"Pesan Mi Ayam"
	)

	UiManager.show_notification(
		"Pandangan mulai kabur..."
	)

	await get_tree().create_timer(
		2.0
	).timeout

	UiManager.show_notification(
		"Aku harus cepat..."
	)


# ==========================================================
# LEVEL 5
# ==========================================================

func setup_level_5() -> void:

	ObjectiveManager.set_objective(
		"Jawab Telepon"
	)

	UiManager.show_notification(
		"Kenapa semuanya terasa sunyi?"
	)

	await get_tree().create_timer(
		2.0
	).timeout

	UiManager.show_notification(
		"Aku tidak bisa menggerakkan tubuhku..."
	)


# ==========================================================
# GET DATA
# ==========================================================

func get_current_level() -> int:

	return current_level


func get_checkpoint() -> int:

	return current_checkpoint


# ==========================================================
# DEBUG
# ==========================================================

func debug_skip_level() -> void:

	next_level()


func debug_load_level(level: int) -> void:

	load_level(
		level
	)
