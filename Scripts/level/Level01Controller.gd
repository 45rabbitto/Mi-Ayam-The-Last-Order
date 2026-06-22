extends Node

enum ChapterState {
	INSPECT,
	TAKE_PHONE,
	FIND_CHARGER,
	CHECK_NOTIFICATION,
	FINISHED
}

var current_state := ChapterState.INSPECT

var inspected_items := {}

var phone_taken := false
var charger_taken := false

const REQUIRED_INSPECTION := [
	"Laptop",
	"Soda",
	"Rokok",
	"Headset",
	"Poster",
]

func _ready() -> void:

	print("LEVEL01 CONTROLLER AKTIF")

	add_to_group("level01")

	print("LEVEL01 READY")

	update_objective(
		"Periksa semua benda di kamar"
	)

# =====================================
# OBJECTIVE
# =====================================

func update_objective(text: String) -> void:

	var hud = get_tree().get_first_node_in_group("hud")

	if hud:
		hud.set_objective(text)

# =====================================
# INSPECTION
# =====================================

func inspect_item(item_name: String) -> void:

	if inspected_items.has(item_name):
		return

	inspected_items[item_name] = true

	print(
		"INSPECT:",
		item_name,
		" TOTAL:",
		inspected_items.size(),
		"/",
		REQUIRED_INSPECTION.size()
	)

	check_inspection_progress()

func check_inspection_progress() -> void:

	for item in REQUIRED_INSPECTION:

		if not inspected_items.has(item):
			print("BELUM DIPERIKSA:", item)
			return
	
	current_state = ChapterState.TAKE_PHONE

	update_objective(
		"Ambil HP di atas meja"
	)

	print("SEMUA OBJEK SUDAH DIPERIKSA")

# =====================================
# PHONE
# =====================================

func take_phone() -> void:

	if current_state != ChapterState.TAKE_PHONE:
		print("HP BELUM BOLEH DIAMBIL")
		return

	if phone_taken:
		return

	phone_taken = true

	current_state = ChapterState.FIND_CHARGER

	print("HP Mati")

	update_objective(
		"Cari charger HP"
	)

# =====================================
# CHARGER
# =====================================

func use_charger() -> void:

	if current_state != ChapterState.FIND_CHARGER:
		print("CHARGER BELUM DIBUTUHKAN")
		return

	if charger_taken:
		return

	charger_taken = true

	current_state = ChapterState.CHECK_NOTIFICATION

	print("HP Menyala")

	update_objective(
		"Periksa notifikasi HP"
	)

	show_missed_call()

# =====================================
# MISSED CALL
# =====================================

func show_missed_call() -> void:

	var hud = get_tree().get_first_node_in_group("hud")

	if hud:
		hud.show_notification(
			"1 Missed Call dari Beni"
		)

	print("MISSED CALL BENI")

	await get_tree().create_timer(3.0).timeout

	update_objective(
		"Jawab panggilan Beni"
	)

	await get_tree().create_timer(3.0).timeout

	current_state = ChapterState.FINISHED

	print("CHAPTER 1 SELESAI")

	LevelManager.next_level()
