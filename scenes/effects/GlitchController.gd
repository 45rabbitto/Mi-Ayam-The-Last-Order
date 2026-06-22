extends CanvasLayer

@onready var color_rect: ColorRect = $ColorRect
@onready var mat: ShaderMaterial = color_rect.material
# Glitch
var intensity: float = 0.0
var target_intensity: float = 0.0

# Shake
var shake_strength: float = 0.0
var original_position: Vector2

func _ready():

	original_position = color_rect.position

# =====================================
# SET GLITCH LEVEL
# 0 - 100
# =====================================
func set_intensity(value: float):

	target_intensity = clamp(
		value / 100.0,
		0.0,
		1.0
	)

# =====================================
# PULSE EFFECT
# =====================================
func pulse(
	amount: float = 80.0,
	duration: float = 0.5
):

	set_intensity(amount)

	await get_tree().create_timer(duration).timeout

	set_intensity(0)

# =====================================
# UPDATE
# =====================================
func _process(delta):

	intensity = lerp(
		intensity,
		target_intensity,
		delta * 3.0
	)

	mat.set_shader_parameter(
		"intensity",
		intensity
	)

	if intensity > 0.01:

		shake_strength = intensity * 10.0

		var offset := Vector2(
			randf_range(
				-shake_strength,
				shake_strength
			),
			randf_range(
				-shake_strength,
				shake_strength
			)
		)

		color_rect.position = (
			original_position + offset
		)

	else:

		color_rect.position = (
			original_position
		)
