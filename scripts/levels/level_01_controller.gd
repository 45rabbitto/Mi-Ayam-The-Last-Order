extends Node

class_name Level01Controller


# =====================================================
# CHAPTER 1 STATE
# =====================================================

enum State {
	ENTER_ROOM,
	INSPECT_OBJECTS,
	TAKE_PHONE,
	FIND_CHARGER,
	CHARGE_PHONE,
	PHONE_ON,
	CHECK_MISSED_CALL,
	FINISHED
}

var current_state : State


# =====================================================
# OBJECT TRACKING
# =====================================================

var inspected_objects := {
	"laptop": false,
	"poster": false,
	"headset": false,
	"rokok": false,
	"soda": false
}


# =====================================================
# READY
# =====================================================

func _ready():

	start_level()


# =====================================================
# START LEVEL
# =====================================================

func start_level():

	current_state = State.INSPECT_OBJECTS

	Hud.set_objective(
		"Periksa semua benda di kamar"
	)

	print("LEVEL 1 STARTED")


# =====================================================
# OBJECT INSPECTED
# =====================================================

func inspect_object(object_name:String):

	if current_state != State.INSPECT_OBJECTS:
		return

	if inspected_objects.has(object_name):

		inspected_objects[object_name] = true

		Hud.show_notification(
			object_name.capitalize() + " diperiksa"
		)

	check_all_inspected()


# =====================================================
# CHECK ALL OBJECTS
# =====================================================

func check_all_inspected():

	for value in inspected_objects.values():

		if value == false:
			return

	current_state = State.TAKE_PHONE

	Hud.show_notification(
		"HP sekarang bisa diambil"
	)

	Hud.set_objective(
		"Ambil HP di meja"
	)

	print("ALL OBJECTS INSPECTED")


# =====================================================
# PHONE PICKED
# =====================================================

func phone_taken():

	if current_state != State.TAKE_PHONE:
		return

	current_state = State.FIND_CHARGER

	InventoryManager.add_item("hp")

	Hud.show_notification(
		"HP diperoleh"
	)

	Hud.show_notification(
		"HP mati..."
	)

	Hud.set_objective(
		"Cari charger"
	)

	print("PHONE TAKEN")


# =====================================================
# CHARGER PICKED
# =====================================================

func charger_taken():

	if current_state != State.FIND_CHARGER:
		return

	InventoryManager.add_item("charger")

	current_state = State.CHARGE_PHONE

	Hud.show_notification(
		"Charger diperoleh"
	)

	Hud.set_objective(
		"Gunakan charger ke HP"
	)

	print("CHARGER TAKEN")


# =====================================================
# CHARGE PHONE
# =====================================================

func charge_phone():

	if current_state != State.CHARGE_PHONE:
		return

	if !InventoryManager.has_item("charger"):
		return

	if !InventoryManager.has_item("hp"):
		return

	current_state = State.PHONE_ON

	Hud.show_notification(
		"HP menyala..."
	)

	await get_tree().create_timer(2.0).timeout

	show_missed_call()


# =====================================================
# MISSED CALL
# =====================================================

func show_missed_call():

	current_state = State.CHECK_MISSED_CALL

	Hud.show_notification(
		"Missed Call dari Beni"
	)

	Hud.set_objective(
		"Periksa panggilan dari Beni"
	)

	print("MISSED CALL SHOWN")


# =====================================================
# CALL CHECKED
# =====================================================

func check_missed_call():

	if current_state != State.CHECK_MISSED_CALL:
		return

	Hud.show_notification(
		"Pesan suara ditemukan"
	)

	await get_tree().create_timer(2.0).timeout

	finish_level()


# =====================================================
# LEVEL COMPLETE
# =====================================================

func finish_level():

	current_state = State.FINISHED

	Hud.set_objective(
		"Chapter selesai"
	)

	Hud.show_notification(
		"Memuat Chapter 2..."
	)

	save_progress()

	await get_tree().create_timer(3.0).timeout

	load_next_level()


# =====================================================
# SAVE
# =====================================================

func save_progress():

	LevelManager.current_level = 2

	if SaveManager:

		SaveManager.save_game()

	print("PROGRESS SAVED")


# =====================================================
# LOAD NEXT LEVEL
# =====================================================

func load_next_level():

	get_tree().change_scene_to_file(
		"res://scenes/levels/level_02_glitch.tscn"
	)

	print("LOAD LEVEL 2")
