extends Node2D

func _ready():
	if OS.get_name() != "Web" and DisplayServer.has_feature(DisplayServer.FEATURE_ORIENTATION):
		DisplayServer.screen_set_orientation(DisplayServer.SCREEN_LANDSCAPE)
	start_breathing_animation()
	check_save_file()
	setup_touch_mode()

func start_breathing_animation():
	if $BackgroundImage/AnimationPlayer.has_animation("breathing"):
		$BackgroundImage/AnimationPlayer.play("breathing")

func check_save_file():
	var has_save = FileAccess.file_exists("user://savegame.save")
	var continue_btn = $MenuPanel/ContinueButton
	continue_btn.disabled = not has_save
	continue_btn.modulate = Color(0.4, 0.4, 0.4, 0.8) if not has_save else Color.WHITE

func setup_touch_mode():
	if OS.get_name() == "Android":
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		var style = StyleBoxFlat.new()
		style.content_margin_left = 20
		style.content_margin_right = 20
		style.content_margin_top = 15
		style.content_margin_bottom = 15
		for btn in [$MenuPanel/StartButton, $MenuPanel/ContinueButton, $MenuPanel/QuitButton]:
			btn.add_theme_stylebox_override("normal", style)
			btn.add_theme_stylebox_override("hover", style)
			btn.add_theme_stylebox_override("pressed", style)

func button_press_effect(button):
	var tween = create_tween()
	tween.tween_property(button, "scale", Vector2(0.95, 0.95), 0.05)
	tween.tween_property(button, "scale", Vector2(1, 1), 0.1)

func _on_start_button_pressed():
	button_press_effect($MenuPanel/StartButton)
	await get_tree().create_timer(0.1).timeout
	DirAccess.remove_absolute("user://savegame.save")
	get_tree().change_scene_to_file("res://scenes/chapters/chapter_1_kamar_kos.tscn")

func _on_continue_button_pressed():
	button_press_effect($MenuPanel/ContinueButton)
	await get_tree().create_timer(0.1).timeout
	var file = FileAccess.open("user://savegame.save", FileAccess.READ)
	if file:
		var saved_scene = file.get_line()
		file.close()
		if ResourceLoader.exists(saved_scene):
			get_tree().change_scene_to_file(saved_scene)

func _on_quit_button_pressed():
	button_press_effect($MenuPanel/QuitButton)
	await get_tree().create_timer(0.1).timeout
	get_tree().quit()
