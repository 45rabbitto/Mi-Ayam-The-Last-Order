extends Node

const SAVE_PATH := "user://level_progress.json"

# =====================================
# LEVEL LIST
# =====================================

const LEVELS := [
	"res://scenes/level/level_01_room",
	"res://scenes/level/level_02_glitch_room.tscn",
	"res://scenes/level/level_03_flashback.tscn",
	"res://scenes/level/level_04_order.tscn",
	"res://scenes/level/level_05_ending.tscn"
]

# =====================================
# CURRENT LEVEL
# =====================================

var current_level: int = 0

# =====================================
# READY
# =====================================

func _ready() -> void:

	load_progress()

# =====================================
# GETTERS
# =====================================

func get_current_level() -> int:

	return current_level

func get_current_level_name() -> String:

	match current_level:

		0:
			return "Kamar Kos"

		1:
			return "Udah Biasa Kok"

		2:
			return "Sebelum Terlambat"

		3:
			return "Serangan"

		4:
			return "Setelah Sunyi"

		_:
			return "Unknown"

# =====================================
# LOAD LEVEL
# =====================================

func load_level(level_index: int) -> void:

	if level_index < 0:
		return

	if level_index >= LEVELS.size():

		print("Game Tamat")
		return

	current_level = level_index

	save_progress()

	print("Load Level:", current_level)

	get_tree().change_scene_to_file(
		LEVELS[current_level]
	)

# =====================================
# NEXT LEVEL
# =====================================

func next_level() -> void:

	var next_level_index := current_level + 1

	if next_level_index >= LEVELS.size():

		print("Ending Reached")
		return

	load_level(next_level_index)

# =====================================
# RESTART LEVEL
# =====================================

func restart_level() -> void:

	load_level(current_level)

# =====================================
# NEW GAME
# =====================================

func new_game() -> void:

	current_level = 0

	save_progress()

	load_level(0)

# =====================================
# CONTINUE GAME
# =====================================

func continue_game() -> void:

	load_progress()

	load_level(current_level)

# =====================================
# SAVE PROGRESS
# =====================================

func save_progress() -> void:

	var data := {
		"current_level": current_level
	}

	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	if file:

		file.store_string(
			JSON.stringify(data)
		)

		file.close()

# =====================================
# LOAD PROGRESS
# =====================================

func load_progress() -> void:

	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.READ
	)

	if file == null:
		return

	var content := file.get_as_text()

	file.close()

	var data = JSON.parse_string(content)

	if data is Dictionary:

		current_level = data.get(
			"current_level",
			0
		)

# =====================================
# RESET SAVE
# =====================================

func delete_save() -> void:

	if FileAccess.file_exists(SAVE_PATH):

		DirAccess.remove_absolute(
			SAVE_PATH
		)

	current_level = 0
