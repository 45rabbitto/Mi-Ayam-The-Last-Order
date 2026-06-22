extends Node

const SAVE_PATH := "user://savegame.json"

var save_data := {
	"player": {
		"position": [0, 0, 0]
	},
	"inventory": [],
	"progress": {
		"level": 1,
		"checkpoint": "start"
	},
	"puzzle": {},
	"raka_state": {
		"met": false,
		"angry": false,
		"dead": false
	}
}

# =========================
# SAVE GAME
# =========================
func save_game(player_node = null):

	if player_node:
		var pos = player_node.global_position
		save_data["player"]["position"] = [pos.x, pos.y, pos.z]

	# INVENTORY SAFE
	if "InventoryManager" in get_tree().root.get_children():
		save_data["inventory"] = InventoryManager.get_items()

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if file:
		file.store_string(JSON.stringify(save_data, "\t"))
		file.close()

		print("Game Saved!")

		# =========================
		# HUD FEEDBACK
		# =========================
		if "Hud" in get_tree().root.get_children():
			Hud.show_notification("💾 Game Saved", 2.0)

# =========================
# LOAD GAME
# =========================
func load_game(player_node = null):

	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found")

		if "Hud" in get_tree().root.get_children():
			Hud.show_notification("❌ No Save File Found", 2.0)

		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if typeof(data) != TYPE_DICTIONARY:
		print("Save corrupted")

		if "Hud" in get_tree().root.get_children():
			Hud.show_notification("⚠ Save Corrupted", 2.0)

		return

	save_data = data

	# PLAYER POSITION
	if player_node:
		var pos = save_data["player"]["position"]
		player_node.global_position = Vector3(pos[0], pos[1], pos[2])

	# INVENTORY LOAD
	if "InventoryManager" in get_tree().root.get_children():
		InventoryManager.items = save_data["inventory"]
		InventoryManager.notify_ui()

	print("Game Loaded!")

	# =========================
	# HUD FEEDBACK
	# =========================
	if "Hud" in get_tree().root.get_children():
		Hud.show_notification("📂 Game Loaded", 2.0)

# =========================
# PROGRESS
# =========================
func set_progress(level: int, checkpoint: String):
	save_data["progress"]["level"] = level
	save_data["progress"]["checkpoint"] = checkpoint

	# HUD optional feedback (story feel)
	if "Hud" in get_tree().root.get_children():
		Hud.set_objective("Level " + str(level) + " - " + checkpoint)

# =========================
# PUZZLE
# =========================
func set_puzzle(name: String, value: bool):
	save_data["puzzle"][name] = value

# =========================
# RAKA STATE
# =========================
func set_raka_state(key: String, value: bool):
	save_data["raka_state"][key] = value

	# HUD HORROR FEEDBACK
	if "HUD" in get_tree().root.get_children():
		if value:
			Hud.set_raka_state("⚠ " + key.to_upper())
		else:
			Hud.set_raka_state("Normal")

# =========================
# DEBUG
# =========================
func get_save_data():
	return save_data
