extends Node

# -----------------------------------------------------
# SCENE PATH
# -----------------------------------------------------

const LEVEL_1 = "res://scenes/level/level_1_room.tscn"
const LEVEL_2 = "res://scenes/level/level_2_glitch_room.tscn"
const LEVEL_3 = "res://scenes/level/level_3_flashback.tscn"
const LEVEL_4 = "res://scenes/level/level_4_order.tscn"
const LEVEL_5 = "res://scenes/level/level_5_ending.tscn"

# -----------------------------------------------------
# DATA
# -----------------------------------------------------

var current_level : int = 1
var current_checkpoint : int = 0

# =====================================================
# LOAD LEVEL
# =====================================================

func load_level(level:int):

	current_level = clamp(level, 1, 5)

	match current_level:

		1:
			get_tree().change_scene_to_file(LEVEL_1)

		2:
			get_tree().change_scene_to_file(LEVEL_2)

		3:
			get_tree().change_scene_to_file(LEVEL_3)

		4:
			get_tree().change_scene_to_file(LEVEL_4)

		5:
			get_tree().change_scene_to_file(LEVEL_5)

	print("====================")
	print("LOAD LEVEL :", current_level)
	print("====================")

	call_deferred("initialize_level")


# =====================================================
# NEXT LEVEL
# =====================================================

func next_level():

	if current_level >= 5:

		print("GAME FINISHED")

		GameManager.is_game_completed = true
		GameManager.game_completed.emit()

		UiManager.notify("Terima kasih telah bermain.")

		return

	load_level(current_level + 1)


# =====================================================
# PREVIOUS LEVEL
# =====================================================

func previous_level():

	if current_level <= 1:
		return

	load_level(current_level - 1)


# =====================================================
# RESTART
# =====================================================

func restart_level():

	print("Restart Level :", current_level)

	load_level(current_level)


# =====================================================
# CHECKPOINT
# =====================================================

func set_checkpoint(id:int):

	current_checkpoint = id

	print("Checkpoint :", id)


func load_checkpoint():

	print("Load Checkpoint :", current_checkpoint)

	load_level(current_level)


# =====================================================
# INITIALIZE LEVEL
# =====================================================

func initialize_level():

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


# =====================================================
# LEVEL 1
# =====================================================

func setup_level_1():

	GameManager.reset_chapter(1)

	ObjectiveManager.set_objective(
		"Periksa seluruh kamar"
	)

	UiManager.notify(
		"HP mati..."
	)

	await get_tree().create_timer(2).timeout

	UiManager.notify(
		"Cari tahu apa yang terjadi."
	)


# =====================================================
# LEVEL 2
# =====================================================
func setup_level_2():

	print("================================")
	print("LEVEL 2 READY")
	print("================================")

	# =====================================================
	# RESET INVENTORY CHAPTER 2
	# =====================================================

	print(
		"INVENTORY SEBELUM RESET : ",
		InventoryManager.get_items()
	)

	InventoryManager.clear_inventory()

	print(
		"INVENTORY SETELAH RESET : ",
		InventoryManager.get_items()
	)

	# =====================================================
	# RESET STATE CHAPTER 2
	# =====================================================

	GameManager.reset_chapter(2)

	print(
		"JUMLAH ITEM : ",
		InventoryManager.get_item_count()
	)

	ObjectiveManager.set_objective(
		"Kembalikan benda ke posisi awal"
	)

	UiManager.show_notification(
		"Kamar ini terasa berbeda..."
	)

	await get_tree().create_timer(2.0).timeout

	UiManager.show_notification(
		"Ingat posisi semua benda."
	)


# =====================================================
# LEVEL 3
# =====================================================

func setup_level_3():

	GameManager.reset_chapter3()

	ObjectiveManager.set_objective(
		"Selesaikan rutinitas malam"
	)

	UiManager.notify(
		"Ingat kembali malam terakhir..."
	)

	await get_tree().create_timer(2).timeout

	UiManager.notify(
		"Selesaikan semuanya sebelum terlambat."
	)


# =====================================================
# LEVEL 4
# =====================================================

func setup_level_4():

	GameManager.reset_chapter4()

	ObjectiveManager.set_objective(
		"Pesan Mi Ayam"
	)

	UiManager.notify(
		"Pandangan mulai kabur..."
	)

	await get_tree().create_timer(2).timeout

	UiManager.notify(
		"Aku harus cepat..."
	)


# =====================================================
# LEVEL 5
# =====================================================

func setup_level_5():

	ObjectiveManager.set_objective(
		"Jawab Telepon"
	)

	UiManager.notify(
		"Kenapa semuanya terasa sunyi?"
	)

	await get_tree().create_timer(2).timeout

	UiManager.notify(
		"Aku tidak bisa menggerakkan tubuhku..."
	)


# =====================================================
# SAVE DATA
# =====================================================

func get_current_level() -> int:
	return current_level


func get_checkpoint() -> int:
	return current_checkpoint


# =====================================================
# DEBUG
# =====================================================

func debug_skip_level():

	next_level()


func debug_load_level(level:int):

	load_level(level)
