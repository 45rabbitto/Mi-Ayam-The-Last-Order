extends Node

# ==========================================================
# OBJECTIVE DATA
# ==========================================================

var current_objective: String = ""

var objective_list: Array[String] = []

var current_index := -1

var objective_completed: Array[String] = []


# ==========================================================
# SET OBJECTIVE
# ==========================================================

func set_objective(text:String):

	current_objective = text

	UiManager.set_objective(text)

	print("OBJECTIVE SET :", text)


# ==========================================================
# CLEAR OBJECTIVE
# ==========================================================

func clear_objective():

	current_objective = ""

	UiManager.set_objective("")

	print("OBJECTIVE CLEARED")


# ==========================================================
# ADD OBJECTIVE
# ==========================================================

func add_objective(text:String):

	objective_list.append(text)

	if current_index == -1:
		next_objective()


# ==========================================================
# START OBJECTIVE
# Dipanggil sekali saat level dimulai
# ==========================================================

func start():

	current_index = -1

	next_objective()


# ==========================================================
# NEXT OBJECTIVE
# ==========================================================

func next_objective():

	current_index += 1

	if current_index >= objective_list.size():

		print("ALL OBJECTIVES COMPLETED")

		clear_objective()

		return

	set_objective(objective_list[current_index])


# ==========================================================
# COMPLETE OBJECTIVE
# ==========================================================

func complete_objective():

	if current_index < 0:
		return

	if current_index >= objective_list.size():
		return

	var completed = objective_list[current_index]

	objective_completed.append(completed)

	if PhoneNotif:
		PhoneNotif.push("✔ Objective selesai : " + completed)

	print("OBJECTIVE COMPLETED :", completed)

	next_objective()


# ==========================================================
# COMPLETE BY ITEM
# Dipanggil saat item berhasil diambil
# ==========================================================

func complete_if_match(item_name:String):

	if current_objective.to_lower().contains(item_name.to_lower()):

		complete_objective()


# ==========================================================
# SET STEP
# ==========================================================

func set_step(index:int):

	if index < 0:
		return

	if index >= objective_list.size():
		return

	current_index = index

	set_objective(objective_list[current_index])


# ==========================================================
# GET CURRENT
# ==========================================================

func get_current_objective() -> String:

	return current_objective


# ==========================================================
# CHECK ITEM SESUAI OBJECTIVE
# ==========================================================

func is_current_item(item_name:String) -> bool:

	return current_objective.to_lower().contains(item_name.to_lower())


# ==========================================================
# CHECK COMPLETED
# ==========================================================

func is_completed(text:String) -> bool:

	return text in objective_completed


# ==========================================================
# RESET
# ==========================================================

func reset():

	current_objective = ""

	objective_list.clear()

	objective_completed.clear()

	current_index = -1

	clear_objective()
