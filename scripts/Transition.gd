extends CanvasLayer

@onready var rect: ColorRect = get_node_or_null("ColorRect")

func _ready():
	if rect:
		rect.modulate.a = 0
	else:
		print("Peringatan: ColorRect tidak ditemukan!")

func fade_out(duration := 1.0) -> void:
	if rect == null:
		print("Gagal fade_out: ColorRect tidak ada.")
		return
	show()
	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 1.0, duration)
	await tween.finished

func fade_in(duration := 1.0) -> void:
	if rect == null:
		print("Gagal fade_in: ColorRect tidak ada.")
		return
	var tween := create_tween()
	tween.tween_property(rect, "modulate:a", 0.0, duration)
	await tween.finished
	hide()
