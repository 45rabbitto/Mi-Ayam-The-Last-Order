extends Node

func _ready():
	
	print("===== MASUK LEVEL2 NORMAL =====")
	print("Scene =", get_tree().current_scene.name)
	
	Global.current_level = 2

	ObjectiveManager.reset()

	ObjectiveManager.add_objective("Buka HP")

	ObjectiveManager.start()
