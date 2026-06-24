extends Node

# =====================================
# LEVEL DATA
# =====================================

var current_level := 1

# =====================================
# CHAPTER 1 STATES
# =====================================

enum Level1State {

	ENTER_ROOM,
	INSPECT_OBJECTS,
	TAKE_PHONE,
	FIND_CHARGER,
	CHARGE_PHONE,
	PHONE_ON,
	CHECK_MISSED_CALL,
	FINISHED
}

var level1_state = Level1State.ENTER_ROOM

# =====================================
# OBJECTIVES
# =====================================

var objectives = {

	Level1State.ENTER_ROOM:
	"Masuk ke kamar",

	Level1State.INSPECT_OBJECTS:
	"Periksa semua benda di kamar",

	Level1State.TAKE_PHONE:
	"Ambil HP",

	Level1State.FIND_CHARGER:
	"Cari charger",

	Level1State.CHARGE_PHONE:
	"Gunakan charger ke HP",

	Level1State.PHONE_ON:
	"HP menyala",

	Level1State.CHECK_MISSED_CALL:
	"Periksa panggilan dari Beni",

	Level1State.FINISHED:
	"Chapter selesai"
}

# =====================================
# SET STATE
# =====================================

func set_level1_state(new_state):

	level1_state = new_state

	print(
		"LEVEL 1 STATE -> ",
		level1_state
	)

	update_hud()

# =====================================
# GET OBJECTIVE
# =====================================

func get_current_objective() -> String:

	if objectives.has(level1_state):

		return objectives[level1_state]

	return "-"

# =====================================
# UPDATE HUD
# =====================================

func update_hud():

	if Hud:

		Hud.set_objective(
			get_current_objective()
		)

# =====================================
# NEXT LEVEL
# =====================================

func load_level(level_number:int):

	current_level = level_number

	match level_number:

		1:
			get_tree().change_scene_to_file(
				"res://scenes/levels/level_1_room.tscn"
			)

		2:
			get_tree().change_scene_to_file(
				"res://scenes/levels/level_2_glitch.tscn"
			)

		3:
			get_tree().change_scene_to_file(
				"res://scenes/levels/level_3_flashback.tscn"
			)

		4:
			get_tree().change_scene_to_file(
				"res://scenes/levels/level_4_order.tscn"
			)

		5:
			get_tree().change_scene_to_file(
				"res://scenes/levels/level_5_ending.tscn"
			)

# =====================================
# SAVE DATA
# =====================================

func get_save_data() -> Dictionary:

	return {

		"current_level": current_level,
		"level1_state": level1_state
	}

# =====================================
# LOAD DATA
# =====================================

func load_save_data(data: Dictionary):

	if data.has("current_level"):
		current_level = data["current_level"]

	if data.has("level1_state"):
		level1_state = data["level1_state"]

	update_hud()
