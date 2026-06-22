extends Node

@export var player: CharacterBody3D
@export var camera: Camera3D

var playing := false

func play_cutscene():

	if playing:
		return

	playing = true

	player.set_process(false)
	player.set_physics_process(false)

	Hud.show_notification(
		"Cutscene dimulai..."
	)

	var start_pos = camera.position

	var target_pos = start_pos + Vector3(
		0,
		0,
		-3
	)

	var tween = get_tree().create_tween()

	tween.tween_property(
		camera,
		"position",
		target_pos,
		3.0
	)

	await tween.finished

	GlitchFX.set_intensity(80)

	await get_tree().create_timer(2.0).timeout

	GlitchFX.set_intensity(0)

	player.set_process(true)
	player.set_physics_process(true)

	playing = false
