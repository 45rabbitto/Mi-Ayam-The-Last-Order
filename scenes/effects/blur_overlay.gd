extends CanvasLayer

@onready var color_rect = $ColorRect
@onready var blur_material: ShaderMaterial = color_rect.material

var current_blur := 0.0

func _ready():
	color_rect.hide()
	set_blur(0)

func enable():
	color_rect.show()

func disable():
	color_rect.hide()

func set_blur(value: float):

	value = clamp(value, 0.0, 100.0)
	current_blur = value

	blur_material.set_shader_parameter(
		"blur_strength",
		value / 100.0
	)

func get_blur() -> float:
	return current_blur

func fade_to(target: float, duration: float = 1.0):

	enable()

	target = clamp(target, 0.0, 100.0)

	var tween = get_tree().create_tween()

	tween.tween_method(
		func(v): set_blur(v),
		current_blur,
		target,
		duration
	)

func pulse(amount: float = 80, duration: float = 0.5):

	enable()

	var old_blur = current_blur

	fade_to(amount, 0.1)

	await get_tree().create_timer(duration).timeout

	fade_to(old_blur, 0.2)
