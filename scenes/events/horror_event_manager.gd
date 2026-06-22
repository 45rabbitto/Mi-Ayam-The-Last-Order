extends Node

# =========================
# CONFIG
# =========================
var event_cooldown := 5.0
var can_trigger := true

# optional references
var player = null

# =========================
# READY
# =========================
func _ready():
	randomize()

# =========================
# REGISTER PLAYER
# =========================
func register_player(p):
	player = p

# =========================
# TRIGGER RANDOM EVENT
# =========================
func trigger_random_event():

	if not can_trigger:
		return

	var events = [
		"whisper",
		"light_flicker",
		"phone_message",
		"shadow",
		"heartbeat"
	]

	var chosen = events[randi() % events.size()]
	call_event(chosen)

	_start_cooldown()

# =========================
# CALL SPECIFIC EVENT
# =========================
func call_event(event_name: String):

	if not can_trigger:
		return

	match event_name:

		"whisper":
			event_whisper()

		"light_flicker":
			event_light_flicker()

		"phone_message":
			event_phone_message()

		"shadow":
			event_shadow()

		"heartbeat":
			event_heartbeat()

	_start_cooldown()

# =====================================================
# 💀 EVENTS
# =====================================================

func event_whisper():
	print("Horror: whisper")

	if PhoneNotif:
		PhoneNotif.push("...kamu mendengar bisikan...")

	if Hud:
		Hud.set_raka_state("Dia sangat dekat...")

func event_phone_message():
	print("Horror: phone message")

	if PhoneNotif:
		PhoneNotif.push("Pesan baru: 'Jangan lihat belakangmu'")

func event_light_flicker():
	print("Horror: light flicker")

	if PhoneNotif:
		PhoneNotif.push("Lampu berkedip...")

func event_shadow():
	print("Horror: shadow")

	if PhoneNotif:
		PhoneNotif.push("Sesuatu bergerak di sudut ruangan...")

	if Hud:
		Hud.set_crosshair(false)

	await get_tree().create_timer(1.0).timeout

	if Hud:
		Hud.set_crosshair(true)

func event_heartbeat():
	print("Horror: heartbeat")

	if PhoneNotif:
		PhoneNotif.push("Detak jantungmu meningkat...")

# =========================
# COOLDOWN SYSTEM
# =========================
func _start_cooldown():

	can_trigger = false

	await get_tree().create_timer(event_cooldown).timeout

	can_trigger = true
