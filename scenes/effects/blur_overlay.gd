extends CanvasLayer

@onready var blur_material: ShaderMaterial = $ColorRect.material

var current_blur := 0.0

func _ready():
	set_blur(0)

# =========================
# SET BLUR
# =========================
func set_blur(value: float):

	value = clamp(value, 0.0, 100.0)

	current_blur = value

	blur_material.set_shader_parameter(
		"blur_strength",
		value / 100.0
	)

# =========================
# GET BLUR
# =========================
func get_blur() -> float:
	return current_blur

# =========================
# FADE BLUR
# =========================
func fade_to(
	target: float,
	duration: float = 1.0
):

	target = clamp(target, 0.0, 100.0)

	var tween = get_tree().create_tween()

	tween.tween_method(
		func(v):
			set_blur(v),
		current_blur,
		target,
		duration
	)

# =========================
# PULSE BLUR
# =========================
func pulse(
	amount: float = 80,
	duration: float = 0.5
):

	var old_blur = current_blur

	fade_to(amount, 0.1)

	await get_tree().create_timer(duration).timeout

	fade_to(old_blur, 0.2)
