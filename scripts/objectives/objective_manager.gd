extends Node

signal objective_changed(text: String)
signal progress_changed(current: int, target: int)
signal objective_completed

# ==========================================================
# CURRENT OBJECTIVE
# ==========================================================

var current_objective: String = ""

# ==========================================================
# OBJECTIVE LIST
# ==========================================================

var objective_list: Array[String] = []
var objective_completed_list: Array[String] = []

var current_index := -1

# ==========================================================
# PROGRESS
# ==========================================================

var current_progress := 0
var target_progress := 0

# ==========================================================
# OBJECTIVE
# ==========================================================

func set_objective(text: String, target := 1):

	current_objective = text

	current_progress = 0
	target_progress = max(target, 1)

	objective_changed.emit(current_objective)
	progress_changed.emit(current_progress, target_progress)


func get_objective() -> String:
	return current_objective


# ==========================================================
# BACKWARD COMPATIBILITY
# ==========================================================

func get_current_objective() -> String:
	return current_objective


func clear_objective():
	clear()


func complete_objective():
	complete_current()


func is_current_item(item_name: String) -> bool:

	if current_objective.is_empty():
		return false

	return current_objective.to_lower().contains(item_name.to_lower())


# ==========================================================
# OBJECTIVE LIST
# ==========================================================

func add_objective(text: String):

	objective_list.append(text)

func start():

	current_index = -1

	next_objective()


func next_objective():

	current_index += 1

	print("NEXT OBJECTIVE")
	print("Index =", current_index)
	print("Size =", objective_list.size())

	if current_index >= objective_list.size():

		print("OBJECTIVE HABIS")

		clear()

		return

	print("OBJECTIVE BARU =", objective_list[current_index])

	set_objective(objective_list[current_index])

func set_step(index: int):

	if index < 0:
		return

	if index >= objective_list.size():
		return

	current_index = index - 1

	next_objective()


func complete_current():

	print("===== COMPLETE CURRENT =====")
	print("Current Index :", current_index)
	print("Objective List :", objective_list)
	print_stack()
	print("Objective Size :", objective_list.size())

	if current_index < 0:
		return

	if current_index >= objective_list.size():
		return

	var completed = objective_list[current_index]

	print("Completed :", completed)

	if completed not in objective_completed_list:
		objective_completed_list.append(completed)

	objective_completed.emit()

	next_objective()

func complete_if_match(item_name: String):

	if is_current_item(item_name):
		complete_current()


func is_completed(text: String) -> bool:

	return text in objective_completed_list


# ==========================================================
# PROGRESS
# ==========================================================

func reset_progress(target := 1):

	current_progress = 0
	target_progress = max(target, 1)

	progress_changed.emit(
		current_progress,
		target_progress
	)


func add_progress(amount := 1):

	if target_progress <= 0:
		return

	current_progress += amount

	current_progress = clamp(
		current_progress,
		0,
		target_progress
	)

	progress_changed.emit(
		current_progress,
		target_progress
	)

	if current_progress >= target_progress:

		complete()


func complete():

	current_progress = target_progress

	progress_changed.emit(
		current_progress,
		target_progress
	)

	objective_completed.emit()


func get_progress() -> int:
	return current_progress


func get_target_progress() -> int:
	return target_progress


func is_progress_completed() -> bool:

	return target_progress > 0 \
	and current_progress >= target_progress


# ==========================================================
# RESET
# ==========================================================

func clear():

	current_objective = ""

	current_progress = 0
	target_progress = 0

	objective_changed.emit("")
	progress_changed.emit(0, 0)


func reset():

	clear()

	objective_list.clear()
	objective_completed_list.clear()

	current_index = -1


# ==========================================================
# SAVE / LOAD
# ==========================================================

func get_save_data() -> Dictionary:

	return {

		"current_objective": current_objective,

		"objective_list": objective_list,

		"objective_completed": objective_completed_list,

		"current_index": current_index,

		"current_progress": current_progress,

		"target_progress": target_progress

	}


func load_save_data(data: Dictionary):

	current_objective = data.get(
		"current_objective",
		""
	)

	objective_list.assign(
		data.get("objective_list", [])
	)

	objective_completed_list.assign(
		data.get("objective_completed", [])
	)

	current_index = data.get(
		"current_index",
		-1
	)

	current_progress = data.get(
		"current_progress",
		0
	)

	target_progress = data.get(
		"target_progress",
		0
	)

	objective_changed.emit(current_objective)

	progress_changed.emit(
		current_progress,
		target_progress
	)
