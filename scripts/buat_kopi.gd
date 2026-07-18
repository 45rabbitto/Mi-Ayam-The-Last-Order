extends CanvasLayer

@onready var rect = $ColorRect
@onready var label = $ColorRect/Label

func _ready():

	hide()

	rect.modulate.a = 0

	label.hide()


func show_message(text:String,duration:=2.0):

	label.text = text

	show()

	var tween = create_tween()

	tween.tween_property(
		rect,
		"modulate:a",
		1.0,
		0.5
	)

	await tween.finished

	label.show()

	await get_tree().create_timer(duration).timeout

	label.hide()

	tween = create_tween()

	tween.tween_property(
		rect,
		"modulate:a",
		0.0,
		0.5
	)

	await tween.finished

	hide()
