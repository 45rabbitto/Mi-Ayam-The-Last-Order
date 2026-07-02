extends Node

const SAVE_PATH := "user://save_game.json"

# ==========================================================
# SAVE
# ==========================================================

func save_game() -> bool:

	var save_data := {

		"game": GameManager.get_save_data(),

		"inventory": InventoryManager.get_save_data(),

		"objective": ObjectiveManager.get_save_data(),

		"level": LevelManager.get_save_data(),

		"player": {
			"position": _get_player_position()
		}

	}

	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	if file == null:

		push_error("Failed to save game.")

		return false

	file.store_string(
		JSON.stringify(save_data, "\t")
	)

	file.close()

	print("Game Saved")

	return true


# ==========================================================
# LOAD
# ==========================================================

func load_game() -> bool:

	if !has_save():
		return false

	var file := FileAccess.open(
		SAVE_PATH,
		FileAccess.READ
	)

	if file == null:
		return false

	var json := JSON.new()

	if json.parse(file.get_as_text()) != OK:

		push_error("Invalid save file.")

		return false

	var data: Dictionary = json.data

	if data.has("game"):
		GameManager.load_save_data(data["game"])

	if data.has("inventory"):
		InventoryManager.load_save_data(data["inventory"])

	if data.has("objective"):
		ObjectiveManager.load_save_data(data["objective"])

	if data.has("level"):
		LevelManager.load_save_data(data["level"])

	if data.has("player"):
		_set_player_position(data["player"])

	print("Game Loaded")

	return true

# ==========================================================
# PLAYER
# ==========================================================

func _get_player_position() -> Dictionary:

	if GameManager.player == null:
		return {}

	return {

		"x": GameManager.player.global_position.x,
		"y": GameManager.player.global_position.y,
		"z": GameManager.player.global_position.z

	}


func _set_player_position(data: Dictionary) -> void:

	if GameManager.player == null:
		return

	if !data.has("position"):
		return

	var pos = data["position"]

	GameManager.player.global_position = Vector3(
		pos.get("x", 0.0),
		pos.get("y", 0.0),
		pos.get("z", 0.0)
	)

# ==========================================================
# SAVE FILE
# ==========================================================

func has_save() -> bool:

	return FileAccess.file_exists(SAVE_PATH)


func delete_save() -> void:

	if has_save():
		DirAccess.remove_absolute(SAVE_PATH)
