extends Node

# =====================================
# PLAYER CONDITION
# =====================================

var raka_condition : int = 100

# =====================================
# LEVEL 1 PROGRESS
# =====================================

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

# =====================================
# GAME STATE
# =====================================

var game_completed : bool = false

# =====================================
# REGISTER INSPECTION
# =====================================

func register_inspection(object_name:String):

	print("=== DEBUG ===")
	print("Objek:", object_name)
	print("Sebelum:", inspected_objects)
	
	if object_name not in inspected_objects:

		inspected_objects.append(object_name)

		print("Sudah diperiksa:", object_name)

		print("Progress:",
			inspected_objects.size(),
			"/",
			required_objects.size()
		)

		check_level_1_progress()

# =====================================
# CHECK OBJECTS
# =====================================

func all_objects_inspected() -> bool:

	for object_name in required_objects:

		if object_name not in inspected_objects:

			return false

	return true

# =====================================
# LEVEL 1 LOGIC
# =====================================

func check_level_1_progress():

	if all_objects_inspected():

		UiManager.notify(
			"Aku sudah memeriksa semuanya."
		)

		ObjectiveManager.set_objective(
			"Ambil HP"
		)

# =====================================
# PHONE
# =====================================

func take_phone():

	if not all_objects_inspected():

		UiManager.notify(
			"Aku harus melihat sekeliling dulu."
		)

		return false

	phone_taken = true

	ObjectiveManager.set_objective(
		"Cari Charger"
	)

	return true

# =====================================
# CHARGER
# =====================================

func find_charger():

	charger_found = true

	UiManager.notify(
		"Charger ditemukan."
	)

	ObjectiveManager.set_objective(
		"Gunakan Charger ke HP"
	)

# =====================================
# CHARGE PHONE
# =====================================

func charge_phone():

	if not charger_found:

		UiManager.notify(
			"Aku belum punya charger."
		)

		return

	phone_charged = true

	UiManager.notify(
		"HP berhasil dinyalakan."
	)

	await get_tree().create_timer(2.0).timeout

	UiManager.notify(
		"1 Missed Call dari Beni"
	)

	await get_tree().create_timer(2.0).timeout

	UiManager.notify(
		"3 Pesan Belum Dibaca"
	)

	ObjectiveManager.set_objective(
		"Periksa pesan dari Beni"
	)

# =====================================
# LEVEL COMPLETE
# =====================================

func complete_level_1():

	UiManager.notify(
		"Menuju level berikutnya..."
	)

	await get_tree().create_timer(2.0).timeout

	LevelManager.next_level()

# =====================================
# CONDITION SYSTEM
# =====================================

func damage_condition(amount:int):

	raka_condition -= amount

	raka_condition = clamp(
		raka_condition,
		0,
		100
	)

	UiManager.update_condition(
		str(raka_condition) + "%"
	)

# =====================================
# RESET LEVEL
# =====================================

func reset_level_data():

	inspected_objects.clear()

	phone_taken = false

	charger_found = false

	phone_charged = false

# =====================================
# NEW GAME
# =====================================

func new_game():

	raka_condition = 100

	reset_level_data()

	LevelManager.load_level(1)
