extends CanvasLayer

var can_skip := false

func _ready():

	await get_tree().create_timer(0.5).timeout

	can_skip = true


func _input(event):

	if !can_skip:
		return

	if event is InputEventMouseButton and event.pressed:
		go_intro()

	elif event.is_action_pressed("ui_accept"):
		go_intro()


func _on_button_pressed():

	print("BUTTON DITEKAN")

	var err = get_tree().change_scene_to_file(
		"res://scenes/intro/IntroStory.tscn"
	)

	print("Error =", err)

func go_intro():

	AudioManager.play_sfx("transition")

	await get_tree().create_timer(0.3).timeout

	get_tree().change_scene_to_file(
		"res://scenes/intro/Intro.tscn"
	)
