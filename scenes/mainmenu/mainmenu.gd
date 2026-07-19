extends Control


# ==========================================================
# READY
# ==========================================================

func _ready():

	print("===== MAIN MENU =====")

	# ======================================================
	# RESET AUDIO
	# ======================================================

	AudioManager.reset_audio()

	AudioManager.play_bgm("main_menu")


	# ======================================================
	# CONTINUE BUTTON
	# ======================================================

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

func button_press_effect(button: Button):

	var tween := create_tween()

	tween.tween_property(
		button,
		"scale",
		Vector2(0.95, 0.95),
		0.05
	)

	tween.tween_property(
		button,
		"scale",
		Vector2(1.0, 1.0),
		0.1
	)


# ==========================================================
# START GAME
# ==========================================================

func _on_start_button_pressed():

	AudioManager.play_ui("click")

	button_press_effect(
		$MenuPanel/StartButton
	)

	await get_tree().create_timer(0.1).timeout

	print("===== START NEW GAME =====")

	GameManager.new_game()


# ==========================================================
# CONTINUE GAME
# ==========================================================

func _on_continue_button_pressed():

	AudioManager.play_ui("click")

	button_press_effect(
		$MenuPanel/ContinueButton
	)

	await get_tree().create_timer(0.1).timeout

	print("===== CONTINUE GAME =====")

	GameManager.load_game()


# ==========================================================
# CREDIT
# ==========================================================

func _on_credit_button_pressed():

	AudioManager.play_ui("click")

	button_press_effect(
		$MenuPanel/CreditButton
	)

	await get_tree().create_timer(0.1).timeout

	get_tree().change_scene_to_file(
		"res://scenes/credit/credit_scene.tscn"
	)


# ==========================================================
# QUIT
# ==========================================================

func _on_quit_button_pressed():
	GameManager.save_game()
	AudioManager.play_ui("click")

	button_press_effect(
		$MenuPanel/QuitButton
	)

	await get_tree().create_timer(0.1).timeout

	get_tree().quit()
