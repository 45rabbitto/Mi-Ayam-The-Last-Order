extends Control


# ==========================================================
# READY
# ==========================================================

func _ready() -> void:

	print("===== MAIN MENU =====")


	AudioManager.reset_audio()


	AudioManager.play_bgm(
		"main_menu"
	)


	var continue_btn: Button = $MenuPanel/ContinueButton


	var has_save: bool = GameManager.has_save()


	continue_btn.disabled = not has_save


	if has_save:

		continue_btn.modulate = Color.WHITE

	else:

		continue_btn.modulate = Color(
			0.583,
			0.583,
			0.583,
			0.8
		)


	print(
		"ADA SAVE : ",
		has_save
	)


# ==========================================================
# BUTTON EFFECT
# ==========================================================

func button_press_effect(button: Button) -> void:

	var tween := create_tween()


	tween.tween_property(
		button,
		"scale",
		Vector2(
			0.95,
			0.95
		),
		0.05
	)


	tween.tween_property(
		button,
		"scale",
		Vector2(
			1.0,
			1.0
		),
		0.1
	)


# ==========================================================
# START NEW GAME
# ==========================================================

func _on_start_button_pressed():

	AudioManager.play_ui("click")

	button_press_effect(
		$MenuPanel/StartButton
	)

	await get_tree().create_timer(0.1).timeout

	print("===== START NEW GAME =====")

	# RESET SEMUA DATA GAME
	GameManager.new_game()

	# RESET AUDIO
	AudioManager.reset_audio()

	# MULAI DARI CHAPTER 1
	GameManager.current_chapter = 1

	LevelManager.current_level = 1

	# MASUK INTRO CHAPTER 1
	get_tree().change_scene_to_file(
		"res://scenes/tutorial.tscn"
	)


# ==========================================================
# CONTINUE GAME
# ==========================================================

func _on_continue_button_pressed() -> void:

	AudioManager.play_ui(
		"click"
	)


	button_press_effect(
		$MenuPanel/ContinueButton
	)


	await get_tree().create_timer(
		0.1
	).timeout


	print("===== CONTINUE GAME =====")


	GameManager.load_game()


# ==========================================================
# CREDIT
# ==========================================================

func _on_credit_button_pressed() -> void:

	AudioManager.play_ui(
		"click"
	)


	button_press_effect(
		$MenuPanel/CreditButton
	)


	await get_tree().create_timer(
		0.1
	).timeout


	get_tree().change_scene_to_file(
		"res://scenes/credit/credit_scene.tscn"
	)


# ==========================================================
# QUIT
# ==========================================================

func _on_quit_button_pressed() -> void:

	AudioManager.play_ui(
		"click"
	)


	button_press_effect(
		$MenuPanel/QuitButton
	)


	await get_tree().create_timer(
		0.1
	).timeout


	GameManager.save_game()


	get_tree().quit()
