extends Node

# =====================================
# LEVEL SCENES
# =====================================

const LEVEL_1 = "res://scenes/level/level-1_room.tscn"
const LEVEL_2 = "res://scenes/level/level_2_glitch-room.tscn"
const LEVEL_3 = "res://scenes/levels/level_3_flashback.tscn"
const LEVEL_4 = "res://scenes/levels/level_4_order.tscn"
const LEVEL_5 = "res://scenes/levels/level_5_ending.tscn"

# =====================================
# LEVEL DATA
# =====================================

var current_level : int = 1
var current_checkpoint : int = 0

# =====================================
# LOAD LEVEL
# =====================================

func load_level(level:int):

	current_level = level

	match level:

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

	print("Load Level:", level)

# =====================================
# NEXT LEVEL
# =====================================

func next_level():

	current_level += 1

	load_level(current_level)

# =====================================
# RESTART LEVEL
# =====================================

func restart_level():

	load_level(current_level)

# =====================================
# CHECKPOINT
# =====================================

func set_checkpoint(id:int):

	current_checkpoint = id

	print("Checkpoint:", id)

func load_checkpoint():

	load_level(current_level)

# =====================================
# LEVEL SETUP
# =====================================

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

# =====================================
# LEVEL 1
# Eksplorasi Kamar
# =====================================

func setup_level_1():

	ObjectiveManager.set_objective(
		"Periksa seluruh kamar"
	)

	UiManager.notify(
		"HP mati. Cari tahu apa yang terjadi."
	)

# =====================================
# LEVEL 2
# Posisikan Objek
# =====================================

func setup_level_2():

	ObjectiveManager.set_objective(
		"Kembalikan benda ke posisi awal"
	)

	UiManager.notify(
		"Ada yang berbeda dengan kamar ini..."
	)

# =====================================
# LEVEL 3
# Flashback
# =====================================

func setup_level_3():

	ObjectiveManager.set_objective(
		"Selesaikan rutinitas malam"
	)

	UiManager.notify(
		"Ingat kembali malam terakhir..."
	)

# =====================================
# LEVEL 4
# Pesan Mi Ayam
# =====================================

func setup_level_4():

	ObjectiveManager.set_objective(
		"Pesan Mi Ayam"
	)

	UiManager.notify(
		"Pandangan mulai kabur..."
	)

# =====================================
# LEVEL 5
# Setelah Sunyi
# =====================================

func setup_level_5():

	ObjectiveManager.set_objective(
		"Jawab Telepon"
	)

	UiManager.notify(
		"Kenapa semuanya terasa berbeda?"
	)
