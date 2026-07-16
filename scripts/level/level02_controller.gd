extends Node3D

var collected := 0
const TOTAL_ITEMS := 4

func _ready():

	print("===== MASUK LEVEL2 GLITCH =====")
	print("Scene =", get_tree().current_scene.name)

	print(get_tree().current_scene.get_tree_string_pretty())

	Global.current_level = 2

	ObjectiveManager.reset()

	ObjectiveManager.add_objective("Jelajahi Kamar")
	ObjectiveManager.add_objective("Kumpulkan Barang")
	ObjectiveManager.add_objective("Tata Ulang Kamar")
	ObjectiveManager.add_objective("Buka HP")

	ObjectiveManager.start()
	
	var hud = get_tree().current_scene.get_node("Hud")

	print("HUD =", hud)
	print("Children HUD = ", hud.get_children())

	var level2ui = hud.get_node("level2ui")

	print("LEVEL2UI =", level2ui)
	print("Children LEVEL2UI = ", level2ui.get_children())

	var explore = level2ui.get_node_or_null("ButtonExplore")
	print("Explore =", explore)

	var rearrange = get_node_or_null("Hud/level2ui/ButtonRearrange")

	if explore:
		explore.show()

	if rearrange:
		rearrange.hide()

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
