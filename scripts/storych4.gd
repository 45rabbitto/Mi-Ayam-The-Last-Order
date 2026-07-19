extends CanvasLayer

@onready var label = $RichTextLabel

var story := """




Tak terasa waktu terus berlalu, hingga fajar hampir tiba. 




"""

var speed := 0.04

func _ready():

	label.text = ""

	show_story()


func show_story():

	AudioManager.start_typing()

	for c in story:

		label.text += c

		await get_tree().create_timer(speed).timeout

	AudioManager.stop_typing()

	await get_tree().create_timer(2.0).timeout

	print("PINDAH KE LEVEL4 PESAN MI AYAM")

	get_tree().change_scene_to_file(
		"res://scenes/level/level_4_order.tscn"
	)

	print("SELESAI PINDAH")
