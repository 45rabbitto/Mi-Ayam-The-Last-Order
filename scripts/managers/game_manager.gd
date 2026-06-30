extends Node

# =====================================================
# GAME MANAGER
# Menyimpan seluruh state permainan
# =====================================================

# =====================================================
# PLAYER
# =====================================================

var raka_condition : int = 100
var current_chapter : int = 1
var game_completed : bool = false

# =====================================================
# CHAPTER 1
# KAMAR KOS
# =====================================================

var inspected_objects : Array[String] = []

var required_objects : Array[String] = [
	"laptop",
	"rokok",
	"soda",
	"poster",
	"headset",
	"meja",
	"kursi"
]

var phone_taken : bool = false
var charger_found : bool = false
var phone_charged : bool = false
var chapter1_completed : bool = false

# =====================================================
# CHAPTER 2
# UDAH BIASA KOK
# =====================================================

var chapter2_completed : bool = false

var object_positions := {
	"phone": false,
	"headset": false,
	"soda": false,
	"rokok": false,
	"charger": false
}

var chapter2_fail_count : int = 0

# =====================================================
# CHAPTER 3
# SEBELUM TERLAMBAT
# =====================================================

var skripsi_done : bool = false
var coffee_done : bool = false
var mabar_done : bool = false
var order_prompt : bool = false

var chapter3_completed : bool = false

# =====================================================
# CHAPTER 4
# SERANGAN
# =====================================================

var food_app_opened : bool = false
var spam_click_count : int = 0
var hold_confirm_done : bool = false
var order_success : bool = false

var chapter4_completed : bool = false

# =====================================================
# GLOBAL FUNCTIONS
# =====================================================

func set_condition(value:int):

	raka_condition = clamp(value,0,100)

	if UiManager:
		UiManager.update_condition(str(raka_condition) + "%")


func damage_condition(amount:int):

	raka_condition -= amount

	raka_condition = clamp(raka_condition,0,100)

	UiManager.update_condition(str(raka_condition)+"%")

	if raka_condition <= 70:
		EffectManager.enable_vignette()

	if raka_condition <= 50:
		EffectManager.enable_blur()

	if raka_condition <= 30:
		EffectManager.enable_glitch()

	if raka_condition <= 10:
		EffectManager.flash_red()


func heal_condition(amount:int):

	set_condition(raka_condition + amount)

# =====================================================
# CHAPTER
# =====================================================

func next_chapter():

	current_chapter += 1

	match current_chapter:

		2:
			LevelManager.load_level(2)

		3:
			LevelManager.load_level(3)

		4:
			LevelManager.load_level(4)

		5:
			LevelManager.load_level(5)

		_:
			game_completed = true


func load_chapter(chapter:int):

	current_chapter = chapter
	LevelManager.load_level(chapter)

# =====================================================
# CHAPTER 1
# =====================================================

func register_inspection(object_name:String):

	if object_name not in inspected_objects:

		inspected_objects.append(object_name)


func all_objects_inspected() -> bool:

	for object_name in required_objects:

		if object_name not in inspected_objects:
			return false

	return true


func complete_chapter1():

	chapter1_completed = true

	next_chapter()

# =====================================================
# CHAPTER 2
# =====================================================

func place_object(object_name:String):

	if object_positions.has(object_name):

		object_positions[object_name] = true


func object_correct(object_name:String) -> bool:

	if object_positions.has(object_name):

		return object_positions[object_name]

	return false


func all_objects_positioned() -> bool:

	for value in object_positions.values():

		if !value:
			return false

	return true


func wrong_position():

	chapter2_fail_count += 1


func complete_chapter2():

	chapter2_completed = true

	next_chapter()

# =====================================================
# CHAPTER 3
# =====================================================

func finish_skripsi():

	skripsi_done = true


func finish_coffee():

	coffee_done = true


func finish_mabar():

	mabar_done = true


func chapter3_ready() -> bool:

	return skripsi_done and coffee_done and mabar_done


func complete_chapter3():

	chapter3_completed = true

	order_prompt = true

	next_chapter()

# =====================================================
# CHAPTER 4
# =====================================================

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

# =====================================================
# RESET
# =====================================================

func reset_chapter1():

	inspected_objects.clear()

	phone_taken = false
	charger_found = false
	phone_charged = false
	chapter1_completed = false


func reset_chapter2():

	object_positions = {
		"phone": false,
		"headset": false,
		"soda": false,
		"rokok": false,
		"charger": false
	}

	chapter2_fail_count = 0
	chapter2_completed = false


func reset_chapter3():

	skripsi_done = false
	coffee_done = false
	mabar_done = false
	order_prompt = false
	chapter3_completed = false


func reset_chapter4():

	food_app_opened = false
	spam_click_count = 0
	hold_confirm_done = false
	order_success = false
	chapter4_completed = false


func reset_all():

	reset_chapter1()
	reset_chapter2()
	reset_chapter3()
	reset_chapter4()

	raka_condition = 100
	current_chapter = 1
	game_completed = false

# =====================================================
# NEW GAME
# =====================================================

func new_game():

	reset_all()

	LevelManager.load_level(1)

# =====================================================
# SAVE DATA
# =====================================================

func get_save_data() -> Dictionary:

	return {
		"condition": raka_condition,
		"chapter": current_chapter,
		"chapter1": chapter1_completed,
		"chapter2": chapter2_completed,
		"chapter3": chapter3_completed,
		"chapter4": chapter4_completed
	}


func load_save_data(data:Dictionary):

	raka_condition = data.get("condition",100)
	current_chapter = data.get("chapter",1)

	chapter1_completed = data.get("chapter1",false)
	chapter2_completed = data.get("chapter2",false)
	chapter3_completed = data.get("chapter3",false)
	chapter4_completed = data.get("chapter4",false)
