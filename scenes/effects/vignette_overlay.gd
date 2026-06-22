extends CanvasLayer

@onready var material_ref: ShaderMaterial = $ColorRect.material

var current_intensity: float = 0.0

func _ready():
	set_intensity(0)

# =========================
# SET INTENSITY
# =========================
func set_intensity(value: float):

	value = clamp(value, 0.0, 100.0)

	current_intensity = value

	material_ref.set_shader_parameter(
		"intensity",
		value / 100.0
	)

# =========================
# GET INTENSITY
# =========================
func get_intensity() -> float:
	return current_intensity

# =========================
# SMOOTH FADE
# =========================
func fade_to(
	target: float,
	duration: float = 1.0
):

	target = clamp(target, 0.0, 100.0)

	var tween = get_tree().create_tween()

	tween.tween_method(
		func(v):
			set_intensity(v),
		current_intensity,
		target,
		duration
	)

# =========================
# PULSE EFFECT
# =========================
func pulse(
	amount: float = 80,
	duration: float = 0.3
):

	var old_value = current_intensity

	fade_to(amount, 0.1)

	await get_tree().create_timer(duration).timeout

	fade_to(old_value, 0.2)
