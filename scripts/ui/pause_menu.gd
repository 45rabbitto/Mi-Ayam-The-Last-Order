extends Control


func _ready():

	visible = false


# =====================================================
# PAUSE
# =====================================================

func pause_game():

	visible = true

	get_tree().paused = true

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func resume_game():

	visible = false

	get_tree().paused = false

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# =====================================================
# BUTTON
# =====================================================

func _on_resume_button_pressed():

	AudioManager.play_ui("click")

	resume_game()


func _on_restart_button_pressed():

	AudioManager.play_ui("click")

	get_tree().paused = false

	InventoryManager.clear_inventory()

	AudioManager.stop_bgm()
	AudioManager.stop_voice()
	AudioManager.stop_typing()

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	get_tree().reload_current_scene()


func _on_main_menu_button_pressed():

	AudioManager.play_ui("click")

	await get_tree().create_timer(0.1).timeout

	get_tree().paused = false

	# RESET INVENTORY
	InventoryManager.clear_inventory()

	# RESET AUDIO
	AudioManager.reset_audio()

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	get_tree().change_scene_to_file(
		"res://scenes/menu/main_menu.tscn"
	)


func _on_quit_button_pressed():

	AudioManager.play_ui("click")

	get_tree().quit()
