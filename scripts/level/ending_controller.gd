extends Node

func _ready():

	Input.set_mouse_mode(
		Input.MOUSE_MODE_VISIBLE
	)

	print("GAME TAMAT")

func restart_game():

	get_tree().change_scene_to_file(
		"res://scenes/levels/level_01.tscn"
	)

func quit_game():

	get_tree().quit()
