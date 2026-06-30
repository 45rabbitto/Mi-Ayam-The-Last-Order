extends Node

signal objective_changed(text : String)
signal progress_changed(current : int, target : int)
signal objective_completed

# =====================================
# OBJECTIVE
# =====================================

var current_objective : String = ""

# =====================================
# PROGRESS
# =====================================

var current_progress : int = 0
var target_progress : int = 0

# =====================================
# SET OBJECTIVE
# =====================================

func set_objective(text : String):

	current_objective = text

	print("--------------------------------")
	print("OBJECTIVE : ", current_objective)
	print("--------------------------------")

	objective_changed.emit(current_objective)

# =====================================
# GET OBJECTIVE
# =====================================

func get_objective() -> String:

	return current_objective

# =====================================
# RESET PROGRESS
# =====================================

func reset_progress(target : int = 1):

	current_progress = 0
	target_progress = target

	progress_changed.emit(
		current_progress,
		target_progress
	)

# =====================================
# ADD PROGRESS
# =====================================

func add_progress(amount : int = 1):

	current_progress += amount

	if current_progress > target_progress:
		current_progress = target_progress

	progress_changed.emit(
		current_progress,
		target_progress
	)

	print(
		"Progress : ",
		current_progress,
		"/",
		target_progress
	)

	if current_progress >= target_progress:

		print("Objective Completed")

		objective_completed.emit()

# =====================================
# COMPLETE
# =====================================

func complete():

	current_progress = target_progress

	progress_changed.emit(
		current_progress,
		target_progress
	)

	objective_completed.emit()

# =====================================
# CLEAR
# =====================================

func clear():

	current_objective = ""

	current_progress = 0

	target_progress = 0

	objective_changed.emit("")

	progress_changed.emit(0,0)

# =====================================
# CHECK
# =====================================

func is_completed() -> bool:

	return current_progress >= target_progress
