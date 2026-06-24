extends Control

@onready var objective_label = $ObjectiveLabel

var current_count := 0
var target_count := 5

func _ready():

	update_objective()

func update_progress(count:int):

	current_count = count

	update_objective()

func update_objective():

	objective_label.text = (
		"Periksa Petunjuk : " +
		str(current_count) +
		" / " +
		str(target_count)
	)

func set_target(value:int):

	target_count = value

	update_objective()
