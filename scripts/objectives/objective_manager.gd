extends Node

signal objective_updated(current, target)
signal objective_completed

var current_progress := 0
var target_progress := 5

func reset_objective(target := 5):

	current_progress = 0
	target_progress = target

	objective_updated.emit(
		current_progress,
		target_progress
	)

func add_progress():

	current_progress += 1

	print(
		"OBJECTIVE: ",
		current_progress,
		"/",
		target_progress
	)

	objective_updated.emit(
		current_progress,
		target_progress
	)

	if current_progress >= target_progress:

		print("OBJECTIVE SELESAI")

		objective_completed.emit()

func is_completed() -> bool:

	return current_progress >= target_progress
