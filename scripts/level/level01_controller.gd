extends Node

@export var total_clues := 5
@export var next_level_scene := "res://scenes/level/level_02.tscn"

var inspected_count := 0

var charger_found := false
var phone_charged := false
var chapter_completed := false

# Daftar objek yang WAJIB diperiksa
var required_clues = [
	"Poster",
	"Laptop",
	"Headset",
	"Rokok",
	"Soda"
]

# Menyimpan objek yang sudah diperiksa
var inspected_objects = []

func _ready():

	add_to_group("level01_controller")

	print("LEVEL 01 READY")

	update_ui()

	show_objective(
		"Periksa benda-benda di kamar (0/%d)" % total_clues
	)


# =====================================================
# INSPECT SYSTEM
# =====================================================

func clue_inspected(object_name: String):
	
	print("=== clue_inspected DIPANGGIL ===")
	print("Objek =", object_name)
	
	if chapter_completed:
		return

	# Cegah hitungan ganda
	if object_name in inspected_objects:

		print(
			object_name,
			" SUDAH PERNAH DIPERIKSA"
		)

		return

	inspected_objects.append(object_name)

	inspected_count = inspected_objects.size()

	print("")
	print("================================")
	print("ITEM DIKLIK :", object_name)
	print(
		"PROGRESS : ",
		inspected_count,
		"/",
		total_clues
	)

	print("SUDAH DIPERIKSA:")
	for item in inspected_objects:
		print(" - ", item)

	print("BELUM DIPERIKSA:")
	for item in required_clues:
		if item not in inspected_objects:
			print(" - ", item)

	print(
		"STATUS => ",
		"CLUE:",
		inspected_count,
		" CHARGER:",
		charger_found,
		" PHONE:",
		phone_charged
	)
	print("================================")
	print("")

	update_ui()

	if inspected_count >= total_clues:

		print("")
		print("SEMUA PETUNJUK DITEMUKAN")
		print("OBJECTIVE BARU : Cari charger HP")
		print("")

		show_objective(
			"Cari charger HP"
		)


# =====================================================
# CHARGER
# =====================================================

func charger_collected():

	if charger_found:
		return

	charger_found = true

	print("")
	print("CHARGER DITEMUKAN")
	print("OBJECTIVE BARU : Charge HP")
	print("")

	show_objective(
		"Charge HP"
	)


# =====================================================
# PHONE
# =====================================================

func phone_interacted():

	if chapter_completed:
		return

	if inspected_count < total_clues:

		print(
			"Periksa semua benda terlebih dahulu!"
		)

		return

	if !charger_found:

		print(
			"HP mati. Cari charger dulu."
		)

		return

	if phone_charged:
		return

	phone_charged = true

	print("")
	print("HP MENYALA")
	print("")

	show_notifications()

	level_complete()


# =====================================================
# UI
# =====================================================

func update_ui():

	var ui = get_tree().get_first_node_in_group(
		"objective_ui"
	)

	if ui and ui.has_method("update_progress"):

		ui.update_progress(
			inspected_count,
			total_clues
		)


func show_objective(text: String):

	print("OBJECTIVE:", text)

	var ui = get_tree().get_first_node_in_group(
		"objective_ui"
	)

	if ui and ui.has_method("set_objective"):

		ui.set_objective(text)


func show_notifications():

	print("")
	print("========================")
	print("1 MISSED CALL")
	print("3 PESAN BARU")
	print("========================")
	print("")

	show_objective(
		"Cek notifikasi HP"
	)


# =====================================================
# COMPLETE
# =====================================================

func level_complete():

	if chapter_completed:
		return

	chapter_completed = true

	print("")
	print("========================")
	print("CHAPTER 1 COMPLETE")
	print("========================")
	print("")

	show_objective(
		"Chapter 1 Complete"
	)

	await get_tree().create_timer(3.0).timeout

	get_tree().change_scene_to_file(
		next_level_scene
	)
