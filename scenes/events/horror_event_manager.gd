extends Node

# ==========================================================
# CONFIG
# ==========================================================

var event_cooldown := 5.0
var can_trigger := true

var player = null

# ==========================================================
# READY
# ==========================================================

func _ready():
	randomize()

# ==========================================================
# REGISTER PLAYER
# ==========================================================

func register_player(p):
	player = p

# ==========================================================
# RANDOM EVENT
# ==========================================================

func trigger_random_event():

	if !can_trigger:
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

# ==========================================================
# CALL EVENT
# ==========================================================

func call_event(event_name:String):

	if !can_trigger:
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

# ==========================================================
# EVENTS
# ==========================================================

func event_whisper():

	print("Horror : Whisper")

	if PhoneNotif:
		PhoneNotif.push("...kamu mendengar bisikan...")

	UiManager.notify("Dia sangat dekat...")

	if EffectManager:
		EffectManager.enable_vignette()

	await get_tree().create_timer(1.5).timeout

	if EffectManager:
		EffectManager.disable_vignette()

# ----------------------------------------------------------

func event_phone_message():

	print("Horror : Phone Message")

	if PhoneNotif:
		PhoneNotif.push("Pesan baru : 'Jangan lihat belakangmu'")

# ----------------------------------------------------------

func event_light_flicker():

	print("Horror : Light Flicker")

	if PhoneNotif:
		PhoneNotif.push("Lampu berkedip...")

	if EffectManager:
		EffectManager.enable_glitch()

	await get_tree().create_timer(0.5).timeout

	if EffectManager:
		EffectManager.disable_glitch()

# ----------------------------------------------------------

func event_shadow():

	print("Horror : Shadow")

	if PhoneNotif:
		PhoneNotif.push("Sesuatu bergerak di sudut ruangan...")

	UiManager.hide_crosshair()

	if EffectManager:
		EffectManager.enable_blur()

	await get_tree().create_timer(1.0).timeout

	if EffectManager:
		EffectManager.disable_blur()

	UiManager.show_crosshair()

# ----------------------------------------------------------

func event_heartbeat():

	print("Horror : Heartbeat")

	if PhoneNotif:
		PhoneNotif.push("Detak jantungmu meningkat...")

	GameManager.damage_condition(5)

	if EffectManager:
		EffectManager.enable_vignette()

	await get_tree().create_timer(0.8).timeout

	if EffectManager:
		EffectManager.disable_vignette()

# ==========================================================
# COOLDOWN
# ==========================================================

func _start_cooldown():

	can_trigger = false

	await get_tree().create_timer(event_cooldown).timeout

	can_trigger = true
