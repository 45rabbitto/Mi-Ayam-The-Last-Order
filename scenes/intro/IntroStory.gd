extends CanvasLayer

@onready var label: RichTextLabel = $RichTextLabel

var intro_text := """
Aku sudah berhari-hari mengurung diri di kamar.

Tapi...

Ada sesuatu yang terasa berbeda malam ini.

Aku terbangun dari ketiduran di depan laptop yang masih menyala.

Berkas skripsiku masih terbuka,
persis seperti sebelum aku tertidur.

Entah kenapa...

Kamar ini terasa lebih sunyi dari biasanya.


"""

var speed := 0.04
var typing := true

func _ready():

	label.text = ""

	show_text()

func show_text():

	AudioManager.start_typing()
	
	for i in intro_text.length():

		label.text += intro_text[i]

		await get_tree().create_timer(speed).timeout
	typing = false

	await get_tree().create_timer(2.0).timeout
	
	AudioManager.stop_typing()

	AudioManager.play_sfx("transition")

	await Transition.fade_out()

	get_tree().change_scene_to_file(
		"res://scenes/level/Level_1_room.tscn"
	)

	await Transition.fade_in()


func _input(event):

	if event.is_action_pressed("ui_accept"):

		get_tree().change_scene_to_file(
			"res://scenes/level/Level_1_room.tscn"
		)
