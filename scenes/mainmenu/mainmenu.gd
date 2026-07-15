extends Control

func _ready():

	# RESET DATA GAME
	InventoryManager.clear_inventory()

	# RESET AUDIO
	AudioManager.reset_audio()

	# PLAY BGM MAIN MENU
	AudioManager.play_bgm("main_menu")


	var has_save = FileAccess.file_exists(
		"user://savegame.save"
	)
	var continue_btn = $MenuPanel/ContinueButton
	continue_btn.disabled = not has_save
	continue_btn.modulate = Color(0.583, 0.583, 0.583, 0.8) if not has_save else Color.WHITE

func button_press_effect(button):
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(0.95, 0.95), 0.05)
	tween.tween_property(button, "scale", Vector2(1, 1), 0.1)

func _on_start_button_pressed():
	
	AudioManager.play_ui("click")

	button_press_effect($MenuPanel/StartButton)
	await get_tree().create_timer(0.1).timeout
	DirAccess.remove_absolute("user://savegame.save")
	get_tree().change_scene_to_file("res://scenes/intro/IntroStory.tscn")

func _on_continue_button_pressed():
	
	AudioManager.play_ui("click")

	button_press_effect($MenuPanel/ContinueButton)
	await get_tree().create_timer(0.1).timeout
	var file = FileAccess.open("user://savegame.save", FileAccess.READ)
	if file:
		var saved_scene = file.get_line()
		file.close()
		if ResourceLoader.exists(saved_scene):
			get_tree().change_scene_to_file(saved_scene)

func _on_credit_button_pressed():
	
	AudioManager.play_ui("click")

	button_press_effect($MenuPanel/CreditButton)
	await get_tree().create_timer(0.1).timeout
	get_tree().change_scene_to_file("res://scenes/credit/credit_scene.tscn")

func _on_quit_button_pressed():
	
	AudioManager.play_ui("click")

	button_press_effect($MenuPanel/QuitButton)
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()
