extends Interactable

@export_multiline var description : String = ""

var inspected := false

func interact():

	if inspected:
		return

	inspected = true

	print("DIPERIKSA :", name)
	print(description)

	var objective = get_tree().get_first_node_in_group(
		"objective_manager"
	)

	if objective:
		objective.object_inspected()
