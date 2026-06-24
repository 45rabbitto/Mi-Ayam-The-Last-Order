extends Node

const SAVE_PATH := "user://save_game.json"

# =====================================================
# PLAYER DATA
# =====================================================

var player_position: Vector3 = Vector3.ZERO

# =====================================================
# RAKA CONDITION
# =====================================================

var raka_condition := 0

# =====================================================
# SAVE GAME
# =====================================================

func save_game():

	var save_data = {

		"player_position": {
			"x": player_position.x,
			"y": player_position.y,
			"z": player_position.z
		},

		"inventory": InventoryManager.get_save_data(),

		"level_data": LevelManager.get_save_data(),

		"raka_condition": raka_condition
	}

	var json_string = JSON.stringify(
		save_data,
		"\t"
	)

	var file = FileAccess.open(
		SAVE_PATH,
		FileAccess.WRITE
	)

	if file == null:

		push_error(
			"Failed to save game."
		)

		return

	file.store_string(
		json_string
	)

	file.close()

	print("GAME SAVED")
