extends Node

# =========================
# OBJECTIVE DATA
# =========================
var current_objective: String = ""
var objective_list: Array = []
var current_index: int = -1

# optional: tracking progress story
var objective_completed: Array = []

# =========================
# SET SINGLE OBJECTIVE
# =========================
func set_objective(text: String):

	current_objective = text

	# update HUD
	if Engine.has_singleton("HUD") or "HUD" in get_tree().root.get_children():
		Hud.set_objective(text)

	# notification
	if Engine.has_singleton("PhoneNotif") or "PhoneNotif" in get_tree().root.get_children():
		PhoneNotif.push("Objective: " + text)

	print("OBJECTIVE SET:", text)


# =========================
# CLEAR OBJECTIVE
# =========================
func clear_objective():

	current_objective = ""

	if Engine.has_singleton("HUD") or "HUD" in get_tree().root.get_children():
		Hud.clear_objective()

	print("OBJECTIVE CLEARED")


# =========================
# ADD OBJECTIVE (QUEUE SYSTEM)
# =========================
func add_objective(text: String):

	objective_list.append(text)

	if current_index == -1:
		next_objective()


# =========================
# NEXT OBJECTIVE
# =========================
func next_objective():

	current_index += 1

	if current_index >= objective_list.size():
		print("ALL OBJECTIVES COMPLETED")
		clear_objective()
		return

	set_objective(objective_list[current_index])


# =========================
# COMPLETE CURRENT OBJECTIVE
# =========================
func complete_objective():

	if current_index < 0 or current_index >= objective_list.size():
		return

	var completed = objective_list[current_index]
	objective_completed.append(completed)

	# notification
	if Engine.has_singleton("PhoneNotif") or "PhoneNotif" in get_tree().root.get_children():
		PhoneNotif.push("✔ Objective selesai: " + completed)

	print("OBJECTIVE COMPLETED:", completed)

	next_objective()


# =========================
# FORCE SET STEP (DEBUG / STORY CONTROL)
# =========================
func set_step(index: int):

	if index < 0 or index >= objective_list.size():
		return

	current_index = index
	set_objective(objective_list[current_index])


# =========================
# GET CURRENT OBJECTIVE
# =========================
func get_current_objective() -> String:
	return current_objective


# =========================
# CHECK IF OBJECTIVE COMPLETED
# =========================
func is_completed(text: String) -> bool:
	return text in objective_completed


# =========================
# RESET ALL (NEW GAME)
# =========================
func reset():

	current_objective = ""
	objective_list.clear()
	objective_completed.clear()
	current_index = -1

	clear_objective()
