extends CanvasLayer

@onready var fade_rect = $ColorRect

func _ready():
	# fade_rect.modulate.a = 0  # <- Komentari sementara
	pass

# =====================================
# FADE OUT
# =====================================

func fade_out(duration := 1.0):
	return  # <- TAMBAHKAN INI, semua kode di bawah di-skip
	var tween = create_tween()
	tween.tween_property(
		fade_rect,
		"modulate:a",
		1.0,
		duration
	)
	await tween.finished

# =====================================
# FADE IN
# =====================================

func fade_in(duration := 1.0):
	return  # <- TAMBAHKAN INI
	var tween = create_tween()
	tween.tween_property(
		fade_rect,
		"modulate:a",
		0.0,
		duration
	)
	await tween.finished
