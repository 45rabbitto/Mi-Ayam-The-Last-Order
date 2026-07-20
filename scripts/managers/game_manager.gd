extends Node


# ==========================================================
# SIGNAL
# ==========================================================

signal condition_changed(value: int)
signal chapter_changed(chapter: int)
signal game_completed


# ==========================================================
# SAVE
# ==========================================================

const SAVE_PATH := "user://savegame.save"


# ==========================================================
# PLAYER
# ==========================================================

var player: CharacterBody3D = null

var raka_condition: int = 100
var current_chapter: int = 1

var is_game_completed: bool = false


# ==========================================================
# CHAPTER 1
# ==========================================================

var inspected_objects: Array[String] = []

const REQUIRED_OBJECTS: Array[String] = [
	"laptop",
	"rokok",
	"soda",
	"poster",
	"headset",
	"meja",
	"kursi"
]

var phone_taken: bool = false
var charger_found: bool = false
var phone_charged: bool = false
var chapter1_completed: bool = false


# ==========================================================
# CHAPTER 2
# ==========================================================

var chapter2_completed: bool = false
var chapter2_fail_count: int = 0

var object_positions: Dictionary = {
	"phone": false,
	"headset": false,
	"soda": false,
	"rokok": false,
	"charger": false
}


# ==========================================================
# CHAPTER 3
# ==========================================================

var skripsi_done: bool = false
var coffee_done: bool = false
var mabar_done: bool = false

var order_prompt: bool = false
var chapter3_completed: bool = false

var chapter3_selected_item: String = ""


# ==========================================================
# CHAPTER 4
# ==========================================================

var food_app_opened: bool = false
var spam_click_count: int = 0
var hold_confirm_done: bool = false
var order_success: bool = false

var chapter4_completed: bool = false


# ==========================================================
# CONDITION
# ==========================================================

func set_condition(value: int) -> void:

	raka_condition = clamp(value, 0, 100)

	condition_changed.emit(raka_condition)


func damage_condition(amount: int) -> void:

	set_condition(
		raka_condition - amount
	)


func heal_condition(amount: int) -> void:

	set_condition(
		raka_condition + amount
	)


# ==========================================================
# CHAPTER
# ==========================================================

func load_chapter(chapter: int) -> void:

	current_chapter = clamp(chapter, 1, 5)

	print(
		"LOAD CHAPTER : ",
		current_chapter
	)

	chapter_changed.emit(current_chapter)

	LevelManager.load_level(
		current_chapter
	)


func next_chapter() -> void:

	if current_chapter >= 5:

		is_game_completed = true

		save_game()

		game_completed.emit()

		return


	current_chapter += 1

	print(
		"================================"
	)

	print(
		"CHAPTER BARU : ",
		current_chapter
	)

	print(
		"================================"
	)

	# SIMPAN CHAPTER TERBARU
	save_game()

	# PINDAH SCENE
	LevelManager.load_level(
		current_chapter
	)

# ==========================================================
# CHAPTER 1
# ==========================================================

func register_inspection(object_name: String) -> void:

	if object_name not in inspected_objects:

		inspected_objects.append(object_name)


func all_objects_inspected() -> bool:

	for object_name in REQUIRED_OBJECTS:

		if object_name not in inspected_objects:

			return false

	return true


func complete_chapter1() -> void:

	print(
		"================================"
	)
	print(
		"COMPLETE CHAPTER 1"
	)
	print(
		"================================"
	)

	chapter1_completed = true

	InventoryManager.clear_inventory()

	next_chapter()
	save_game()

# ==========================================================
# CHAPTER 2
# ==========================================================

func place_object(object_name: String) -> void:

	if object_positions.has(object_name):

		object_positions[object_name] = true


func is_object_positioned(object_name: String) -> bool:

	return object_positions.get(
		object_name,
		false
	)


func all_objects_positioned() -> bool:

	for value in object_positions.values():

		if not value:

			return false

	return true


func add_fail() -> void:

	chapter2_fail_count += 1


func complete_chapter2() -> void:

	print(
		"================================"
	)
	print(
		"COMPLETE CHAPTER 2"
	)
	print(
		"================================"
	)

	chapter2_completed = true

	next_chapter()
	
	save_game()


# ==========================================================
# CHAPTER 3
# ==========================================================

func finish_skripsi() -> void:

	skripsi_done = true


func finish_coffee() -> void:

	coffee_done = true


func finish_mabar() -> void:

	mabar_done = true


func is_chapter3_ready() -> bool:

	return (
		skripsi_done
		and coffee_done
		and mabar_done
	)


func select_chapter3_item(item_id: String) -> void:

	chapter3_selected_item = item_id


func get_chapter3_selected_item() -> String:

	return chapter3_selected_item


func clear_chapter3_selected_item() -> void:

	chapter3_selected_item = ""


func complete_chapter3() -> void:

	print(
		"================================"
	)
	print(
		"COMPLETE CHAPTER 3"
	)
	print(
		"================================"
	)

	chapter3_completed = true

	order_prompt = true
	
	next_chapter()
	save_game()
	


# ==========================================================
# CHAPTER 4
# ==========================================================

func open_food_app() -> void:

	food_app_opened = true


func add_spam_click() -> void:

	spam_click_count += 1


func finish_hold_confirm() -> void:

	hold_confirm_done = true


func complete_order() -> void:

	order_success = true


func complete_chapter4() -> void:

	print(
		"================================"
	)
	print(
		"COMPLETE CHAPTER 4"
	)
	print(
		"================================"
	)

	chapter4_completed = true

	next_chapter()
	save_game()

	


# ==========================================================
# RESET
# ==========================================================

func reset_chapter(chapter: int) -> void:

	match chapter:

		1:

			inspected_objects.clear()

			phone_taken = false
			charger_found = false
			phone_charged = false
			chapter1_completed = false


		2:

			object_positions = {
				"phone": false,
				"headset": false,
				"soda": false,
				"rokok": false,
				"charger": false
			}

			chapter2_fail_count = 0
			chapter2_completed = false


		3:

			skripsi_done = false
			coffee_done = false
			mabar_done = false

			order_prompt = false
			chapter3_completed = false

			chapter3_selected_item = ""


		4:

			food_app_opened = false
			spam_click_count = 0
			hold_confirm_done = false
			order_success = false

			chapter4_completed = false


func reset_all() -> void:

	reset_chapter(1)
	reset_chapter(2)
	reset_chapter(3)
	reset_chapter(4)

	raka_condition = 100
	current_chapter = 1
	is_game_completed = false


func new_game() -> void:

	reset_all()

	InventoryManager.clear_inventory()

	ObjectiveManager.clear()
	
	save_game()


# ==========================================================
# SAVE DATA
# ==========================================================

func get_save_data() -> Dictionary:

	return {

		"condition": raka_condition,

		"current_chapter": current_chapter,

		"is_game_completed": is_game_completed,


		# CHAPTER 1

		"inspected_objects": inspected_objects,

		"phone_taken": phone_taken,

		"charger_found": charger_found,

		"phone_charged": phone_charged,

		"chapter1_completed": chapter1_completed,


		# CHAPTER 2

		"object_positions": object_positions,

		"chapter2_fail_count": chapter2_fail_count,

		"chapter2_completed": chapter2_completed,


		# CHAPTER 3

		"skripsi_done": skripsi_done,

		"coffee_done": coffee_done,

		"mabar_done": mabar_done,

		"order_prompt": order_prompt,

		"chapter3_selected_item": chapter3_selected_item,

		"chapter3_completed": chapter3_completed,


		# CHAPTER 4

		"food_app_opened": food_app_opened,

		"spam_click_count": spam_click_count,

		"hold_confirm_done": hold_confirm_done,

		"order_success": order_success,

		"chapter4_completed": chapter4_completed

	}


func load_save_data(data: Dictionary) -> void:

	raka_condition = data.get(
		"condition",
		100
	)

	current_chapter = clamp(
		int(
			data.get(
				"current_chapter",
				1
			)
		),
		1,
		5
	)

	is_game_completed = data.get(
		"is_game_completed",
		false
	)


	# ======================================================
	# CHAPTER 1
	# ======================================================

	inspected_objects.clear()

	var saved_inspected_objects = data.get(
		"inspected_objects",
		[]
	)

	for object_name in saved_inspected_objects:

		if object_name is String:

			inspected_objects.append(
				object_name
			)


	phone_taken = data.get(
		"phone_taken",
		false
	)

	charger_found = data.get(
		"charger_found",
		false
	)

	phone_charged = data.get(
		"phone_charged",
		false
	)

	chapter1_completed = data.get(
		"chapter1_completed",
		false
	)


	# ======================================================
	# CHAPTER 2
	# ======================================================

	var saved_positions = data.get(
		"object_positions",
		{}
	)

	object_positions = {
		"phone": bool(
			saved_positions.get(
				"phone",
				false
			)
		),

		"headset": bool(
			saved_positions.get(
				"headset",
				false
			)
		),

		"soda": bool(
			saved_positions.get(
				"soda",
				false
			)
		),

		"rokok": bool(
			saved_positions.get(
				"rokok",
				false
			)
		),

		"charger": bool(
			saved_positions.get(
				"charger",
				false
			)
		)
	}


	chapter2_fail_count = int(
		data.get(
			"chapter2_fail_count",
			0
		)
	)

	chapter2_completed = data.get(
		"chapter2_completed",
		false
	)


	# ======================================================
	# CHAPTER 3
	# ======================================================

	skripsi_done = data.get(
		"skripsi_done",
		false
	)

	coffee_done = data.get(
		"coffee_done",
		false
	)

	mabar_done = data.get(
		"mabar_done",
		false
	)

	order_prompt = data.get(
		"order_prompt",
		false
	)

	chapter3_selected_item = data.get(
		"chapter3_selected_item",
		""
	)

	chapter3_completed = data.get(
		"chapter3_completed",
		false
	)


	# ======================================================
	# CHAPTER 4
	# ======================================================

	food_app_opened = data.get(
		"food_app_opened",
		false
	)

	spam_click_count = int(
		data.get(
			"spam_click_count",
			0
		)
	)

	hold_confirm_done = data.get(
		"hold_confirm_done",
		false
	)

	order_success = data.get(
		"order_success",
		false
	)

	chapter4_completed = data.get(
		"chapter4_completed",
		false
	)


	condition_changed.emit(
		raka_condition
	)

	chapter_changed.emit(
		current_chapter
	)


# ==========================================================
# SAVE GAME
# ==========================================================

func save_game() -> void:
	print(
		"SAVE DEBUG | GAME CHAPTER : ",
		current_chapter,
		" | LEVEL : ",
		LevelManager.current_level
	)
	var save_data: Dictionary = {

		"game": get_save_data(),

		"inventory": InventoryManager.get_save_data()

	}


	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)


	if file == null:

		print(
			"GAGAL MENYIMPAN GAME"
		)

		return


	file.store_string(
		JSON.stringify(save_data)
	)

	file.close()


	print(
		"=============================="
	)

	print(
		"GAME BERHASIL DISIMPAN"
	)

	print(
		"CHAPTER : ",
		current_chapter
	)

	print(
		"=============================="
	)


# ==========================================================
# HAS SAVE
# ==========================================================

func has_save() -> bool:

	return FileAccess.file_exists(
		SAVE_PATH
	)


# ==========================================================
# LOAD GAME
# ==========================================================

func load_game() -> void:

	if not has_save():

		print(
			"SAVE TIDAK DITEMUKAN"
		)

		return


	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.READ
	)


	if file == null:

		print(
			"GAGAL MEMBUKA SAVE"
		)

		return


	var content := file.get_as_text()

	file.close()


	var data = JSON.parse_string(
		content
	)


	if data == null:

		print(
			"SAVE RUSAK"
		)

		return


	load_save_data(
		data.get(
			"game",
			{}
		)
	)


	InventoryManager.load_save_data(
		data.get(
			"inventory",
			{}
		)
	)


	print(
		"=============================="
	)

	print(
		"GAME BERHASIL DI-LOAD"
	)

	print(
		"LANJUT CHAPTER : ",
		current_chapter
	)

	print(
		"=============================="
	)


	# PENTING
	# AMBIL DARI GAME MANAGER
	var saved_chapter: int = current_chapter

	LevelManager.load_level(
		saved_chapter
	)


# ==========================================================
# AUTO SAVE
# ==========================================================

func _notification(what: int) -> void:

	if what == NOTIFICATION_WM_CLOSE_REQUEST:

		print(
			"GAME DITUTUP - AUTO SAVE"
		)

		save_game()

		get_tree().quit()
