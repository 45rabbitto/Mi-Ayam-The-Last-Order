extends CanvasLayer


var target_scene: String = "res://scenes/level/Level_2_Normal.tscn"

@onready var fade_rect: ColorRect = $ColorRect


func _ready():

	print("Loading mulai")


	if AudioManager:

		AudioManager.play_sfx(
			"transition"
		)


	await get_tree().create_timer(
		2.0
	).timeout


	print("Timer selesai")


	var tween := create_tween()

	tween.tween_property(
		fade_rect,
		"color:a",
		0.0,
		1.0
	)


	await tween.finished


	print("Fade selesai")


	print(
		"Pindah scene ke: ",
		target_scene
	)


	var err := get_tree().change_scene_to_file(
		target_scene
	)


	if err != OK:

		print(
			"GAGAL PINDAH KE SCENE TARGET! Error code: ",
			err
		)
