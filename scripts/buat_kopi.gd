extends CanvasLayer

@onready var rect: ColorRect = $ColorRect
@onready var label: Label = $ColorRect/Label

func _ready() -> void:
	hide()
	rect.modulate.a = 0
	label.hide()


func show_message(text: String, duration: float = 2.0) -> void:
	label.text = text

	show()
	var tween_in := create_tween()
	tween_in.tween_property(rect, "modulate:a", 1.0, 0.5)
	await tween_in.finished

	label.show()
	await get_tree().create_timer(duration).timeout

	label.hide()
	var tween_out := create_tween()
	tween_out.tween_property(rect, "modulate:a", 0.0, 0.5)
	await tween_out.finished

	hide()
