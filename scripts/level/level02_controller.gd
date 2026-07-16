extends Node3D

var collected := 0
const TOTAL_ITEMS := 4

var selected_inventory_item := ""
var rearrange_mode := false

func _ready():

	print("===== MASUK LEVEL2 GLITCH =====")
	print("Scene =", get_tree().current_scene.name)

	print(
		get_tree().current_scene.get_tree_string_pretty()
	)

	Global.current_level = 2


	# ======================================================
	# OBJECTIVE
	# ======================================================

	ObjectiveManager.reset()

	ObjectiveManager.add_objective(
		"Jelajahi Kamar"
	)

	ObjectiveManager.add_objective(
		"Kumpulkan Barang"
	)

	ObjectiveManager.add_objective(
		"Tata Ulang Kamar"
	)

	ObjectiveManager.add_objective(
		"Buka HP"
	)

	ObjectiveManager.start()


	# ======================================================
	# UI LEVEL 2
	# ======================================================

	var level2ui = get_tree().current_scene.get_node_or_null(
		"Hud/level2ui"
	)

	if level2ui == null:

		print("LEVEL2UI TIDAK DITEMUKAN")

		return


	var explore = level2ui.get_node_or_null(
		"ButtonExplore"
	)

	var rearrange = level2ui.get_node_or_null(
		"ButtonRearrange"
	)


	if explore:

		explore.show()


	if rearrange:

		if !rearrange.pressed.is_connected(
			start_rearrange_mode
		):

			rearrange.pressed.connect(
				start_rearrange_mode
			)

		rearrange.hide()


	# ======================================================
	# CONNECT INTERACTABLE
	# ======================================================

	_connect_interactables()

func _connect_interactables():

	var objects = get_tree().get_nodes_in_group("interactable")

	for obj in objects:

		if obj.interacted.is_connected(on_item_collected):
			continue

		obj.interacted.connect(on_item_collected)


func on_item_collected(item_id:String):

	match item_id:

		"laptop", "headset", "rokok", "poster":

			collected += 1

			print("Collected :", collected)

			if collected >= TOTAL_ITEMS:

				if ObjectiveManager.get_current_objective() == "Kumpulkan Barang":

					ObjectiveManager.complete_current()

					show_rearrange_button()

func show_rearrange_button():
	var btn = get_tree().current_scene.get_node_or_null(
		"Hud/level2ui/ButtonRearrange"
	)
	if btn:
		btn.show()
	
	var world_label = get_tree().current_scene.get_node_or_null(
		"PATH/KE/ButtonRearrange"  # ganti sesuai path asli
	)
	if world_label:
		world_label.show()
		
		
func start_rearrange_mode():

	print("================================")
	print("MODE TATA ULANG DIMULAI")
	print(
		"INVENTORY SEBELUM : ",
		InventoryManager.get_items()
	)
	print("================================")

	rearrange_mode = true
	
	# HAPUS ITEM CHAPTER 2
	InventoryManager.remove_item("laptop")
	InventoryManager.remove_item("headset")
	InventoryManager.remove_item("rokok")
	InventoryManager.remove_item("poster")


	# RESET ITEM TERPILIH
	selected_inventory_item = ""


	print(
		"INVENTORY SESUDAH : ",
		InventoryManager.get_items()
	)


	# PINDAH KE OBJECTIVE TATA ULANG
	ObjectiveManager.complete_current()

	UiManager.show_notification(
		"Klik tombol lanjut atau tekan tombol 1"
	)

func continue_to_level2_normal():

	if !rearrange_mode:
		return

	print("LANJUT KE LEVEL 2 NORMAL")

	rearrange_mode = false

	get_tree().change_scene_to_file(
		"res://scenes/level/Level_2_Normal.tscn"
	)
	
func _unhandled_input(event):

	if rearrange_mode:

		if event.is_action_pressed("slot1"):

			print("TOMBOL 1 DITEKAN")

			continue_to_level2_normal()

			return
