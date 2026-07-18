extends Node

# ==========================================================
# GAME MANAGER
# Menyimpan seluruh state permainan
# ==========================================================

signal condition_changed(value:int)
signal chapter_changed(chapter:int)
signal game_completed

# ==========================================================
# PLAYER
# ==========================================================

var player: CharacterBody3D = null

var raka_condition := 100
var current_chapter := 1

var is_game_completed := false

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

var phone_taken := false
var charger_found := false
var phone_charged := false
var chapter1_completed := false

# ==========================================================
# CHAPTER 2
# ==========================================================

var chapter2_completed := false
var chapter2_fail_count := 0

var object_positions := {
	"phone": false,
	"headset": false,
	"soda": false,
	"rokok": false,
	"charger": false
}

# ==========================================================
# CHAPTER 3
# ==========================================================

var skripsi_done := false
var coffee_done := false
var mabar_done := false

var order_prompt := false
var chapter3_completed := false

var chapter3_selected_item: String = ""
func select_chapter3_item(item_id: String) -> void:

	chapter3_selected_item = item_id

	print(
		"CHAPTER 3 ITEM DIPILIH : ",
		chapter3_selected_item
	)


func get_chapter3_selected_item() -> String:

	return chapter3_selected_item


func clear_chapter3_selected_item() -> void:

	chapter3_selected_item = ""

# ==========================================================
# CHAPTER 4
# ==========================================================

var food_app_opened := false
var spam_click_count := 0
var hold_confirm_done := false
var order_success := false

var chapter4_completed := false

# ==========================================================
# CONDITION
# ==========================================================

func set_condition(value:int):

	raka_condition = clamp(value, 0, 100)

	condition_changed.emit(raka_condition)


func damage_condition(amount:int):

	set_condition(raka_condition - amount)


func heal_condition(amount:int):

	set_condition(raka_condition + amount)


# ==========================================================
# CHAPTER
# ==========================================================

func load_chapter(chapter:int):

	current_chapter = chapter

	chapter_changed.emit(current_chapter)

	LevelManager.load_level(current_chapter)


func next_chapter():

	if current_chapter >= 5:

		is_game_completed = true

		game_completed.emit()

		return

	load_chapter(current_chapter + 1)


# ==========================================================
# CHAPTER 1
# ==========================================================

func register_inspection(object_name:String):

	if object_name in inspected_objects:
		return

	inspected_objects.append(object_name)


func all_objects_inspected() -> bool:

	for object_name in REQUIRED_OBJECTS:

		if object_name not in inspected_objects:
			return false

	return true


func complete_chapter1():

	print("================================")
	print("CHAPTER 1 SELESAI")
	print("================================")

	chapter1_completed = true
	InventoryManager.clear_inventory()
	print("INVENTORY SEBELUM CHAPTER 2 : ",
		InventoryManager.get_items()
	)

	next_chapter()


# ==========================================================
# CHAPTER 2
# ==========================================================

func place_object(object_name:String):

	if object_positions.has(object_name):

		object_positions[object_name] = true


func is_object_positioned(object_name:String) -> bool:

	return object_positions.get(object_name, false)


func all_objects_positioned() -> bool:

	for value in object_positions.values():

		if !value:
			return false

	return true


func add_fail():

	chapter2_fail_count += 1


func complete_chapter2():

	chapter2_completed = true

	next_chapter()


# ==========================================================
# CHAPTER 3
# ==========================================================

func finish_skripsi():
	skripsi_done = true


func finish_coffee():
	coffee_done = true


func finish_mabar():
	mabar_done = true


func is_chapter3_ready() -> bool:

	return skripsi_done and coffee_done and mabar_done


func complete_chapter3():

	chapter3_completed = true

	order_prompt = true

	next_chapter()


# ==========================================================
# CHAPTER 4
# ==========================================================

func open_food_app():
	food_app_opened = true


func add_spam_click():
	spam_click_count += 1


func finish_hold_confirm():
	hold_confirm_done = true


func complete_order():
	order_success = true


func complete_chapter4():

	chapter4_completed = true

	next_chapter()


# ==========================================================
# RESET
# ==========================================================

func reset_chapter(chapter:int):

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

		4:
			food_app_opened = false
			spam_click_count = 0
			hold_confirm_done = false
			order_success = false
			chapter4_completed = false


func reset_all():

	for chapter in range(1, 5):
		reset_chapter(chapter)

	raka_condition = 100
	current_chapter = 1
	is_game_completed = false


# ==========================================================
# NEW GAME
# ==========================================================

func new_game():

	reset_all()

	InventoryManager.clear_inventory()

	ObjectiveManager.clear()

	LevelManager.load_level(1)


# ==========================================================
# SAVE
# ==========================================================

func get_save_data() -> Dictionary:

	return {
		"condition": raka_condition,
		"chapter": current_chapter,
		"chapter1_completed": chapter1_completed,
		"chapter2_completed": chapter2_completed,
		"chapter3_completed": chapter3_completed,
		"chapter4_completed": chapter4_completed
	}


func load_save_data(data:Dictionary):

	raka_condition = data.get("condition", 100)
	current_chapter = data.get("chapter", 1)

	chapter1_completed = data.get("chapter1_completed", false)
	chapter2_completed = data.get("chapter2_completed", false)
	chapter3_completed = data.get("chapter3_completed", false)
	chapter4_completed = data.get("chapter4_completed", false)

	condition_changed.emit(raka_condition)
	chapter_changed.emit(current_chapter)
