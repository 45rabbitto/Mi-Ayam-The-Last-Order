extends CanvasLayer

@onready var label = $RichTextLabel

var story := """
Setelah berhasil menyalakan handphone, Raka merasa ada sesuatu yang tidak beres.
Saat menoleh ke sekeliling, ia membeku.

Jam di dinding berputar tidak beraturan.

Raka memegang perutnya sesaat.

Bukan karena sakit.

Melainkan karena sensasi panas itu...
terasa sangat familiar.
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

	print("PINDAH KE LEVEL2 GLITCH")

	get_tree().change_scene_to_file(
		"res://scenes/level/level_2_glitch_room.tscn"
	)

	print("SELESAI PINDAH")
