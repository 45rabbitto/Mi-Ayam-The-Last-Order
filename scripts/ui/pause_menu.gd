extends Control

func _ready():

	visible = false

func _input(event):

	if event.is_action_pressed("ui_cancel"):

		if visible:
			resume_game()
		else:
			pause_game()

func pause_game():

	visible = true
	get_tree().paused = true

func resume_game():

	visible = false
	get_tree().paused = false

func _on_resume_button_pressed():
	
	AudioManager.play_ui("click")

	resume_game()

func _on_restart_button_pressed():
	
	AudioManager.play_ui("click")

	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_quit_button_pressed():
	
	AudioManager.play_ui("click")

	get_tree().quit()
