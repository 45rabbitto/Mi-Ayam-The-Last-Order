extends Node3D

@export var is_open := false
@export var open_angle := 90.0
@export var speed := 5.0

var player_in_range := false

func _process(delta):

	# animasi buka/tutup pintu
	var target_rotation = Vector3.ZERO

	if is_open:
		target_rotation = Vector3(0, open_angle, 0)

	rotation_degrees = rotation_degrees.lerp(target_rotation, speed * delta)


# =========================
# INTERACT FUNCTION (WAJIB UNTUK RAYCAST SYSTEM)
# =========================
func interact(player):

	is_open = !is_open

	if is_open:
		Hud.show_notification("🚪 Pintu terbuka", 2.0)
		Hud.set_objective("Cari jalan berikutnya")
	else:
		Hud.show_notification("🚪 Pintu tertutup", 2.0)


# =========================
# PROMPT UNTUK HUD (TEXT INTERAKSI)
# =========================
func get_prompt() -> String:

	if is_open:
		return "Tekan E untuk menutup pintu"
	else:
		return "Tekan E untuk membuka pintu"
