extends CanvasLayer

@onready var fade_rect = $ColorRect

func _ready():

	fade_rect.modulate.a = 0

# =====================================
# FADE OUT
# =====================================

func fade_out(duration := 1.0):

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

	var tween = create_tween()

	tween.tween_property(
		fade_rect,
		"modulate:a",
		0.0,
		duration
	)

	await tween.finished
