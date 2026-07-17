extends CanvasLayer

@onready var label = $RichTextLabel

var story := """


kamar kembali rapi.
Kamar juga terlihat sama. 

Jam menunjukkan 23.00. 

Laptop Raka terbuka dengan skripsi.

Raka duduk di kursi, membentangkan jari di atas keyboard.




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

	print("PINDAH KE LEVEL3 FLASHBACK")

	get_tree().change_scene_to_file(
		"res://scenes/level/level_3_flashback.tscn"
	)

	print("SELESAI PINDAH")
