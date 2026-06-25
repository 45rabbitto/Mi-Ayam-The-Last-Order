extends Control

func _on_back_button_pressed():
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/mainmenu/mainmenu.tscn")
