extends Node

@export var total_clues := 5
@export var ending_scene := "res://scenes/levels/ending.tscn"

var inspected_count := 0

func _ready():

	print("LEVEL 02 READY")

	update_ui()

func clue_inspected(object_name:String):

	inspected_count += 1

	print(
		"INSPECT:",
		object_name,
		" TOTAL:",
		inspected_count,
		"/",
		total_clues
	)

	update_ui()

	if inspected_count >= total_clues:
		level_complete()

func update_ui():

	var ui = get_tree().get_first_node_in_group(
		"objective_ui"
	)

	if ui:
		ui.update_progress(
			inspected_count,
			total_clues
		)

func level_complete():

	print("LEVEL 02 SELESAI")

	await get_tree().create_timer(2.0).timeout

	get_tree().change_scene_to_file(
		ending_scene
	)
