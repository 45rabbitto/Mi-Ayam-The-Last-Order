extends Node

const SAVE_PATH := "user://savegame.json"

# struktur data save
var save_data := {
	"current_level": 0,
	"inventory": [],
	"inspected_objects": {},
	"story_flags": {}
}

# ================================
# SAVE GAME
# ================================
func save_game():
	
	save_data["current_level"] = LevelManager.current_level
	save_data["inventory"] = InventoryManager.items
	save_data["inspected_objects"] = LevelManager.inspected_objects
	save_data["story_flags"] = LevelManager.story_flags

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_string(JSON.stringify(save_data))
		file.close()
		print("SAVE SUCCESS")
	else:
		print("SAVE FAILED")


# ================================
# LOAD GAME
# ================================
func load_game():
	
	if not FileAccess.file_exists(SAVE_PATH):
		print("NO SAVE FILE FOUND")
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()

	var result = JSON.parse_string(content)

	if result == null:
		print("SAVE CORRUPTED")
		return

	save_data = result

	# restore data
	LevelManager.current_level = save_data["current_level"]
	InventoryManager.items = save_data["inventory"]
	LevelManager.inspected_objects = save_data["inspected_objects"]
	LevelManager.story_flags = save_data["story_flags"]

	InventoryManager.inventory_changed.emit()

	print("LOAD SUCCESS")


# ================================
# RESET SAVE
# ================================
func reset_save():
	
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)
		print("SAVE DELETED")
