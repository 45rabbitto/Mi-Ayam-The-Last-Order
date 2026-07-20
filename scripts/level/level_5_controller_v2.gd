extends Node3D

# =====================================================
# STATE FLAGS
# =====================================================
var hp_ringing := true
var has_tried_hp := false
var has_tried_pintu := false
var ending_triggered := false
var flicker_active := true
var ambient_active := true

# =====================================================
# READY
# =====================================================
func _ready():
	print("=== LEVEL 5 (SETELAH SUNYI) READY ===")
	Global.current_level = 5
	GameManager.current_chapter = 5
	LevelManager.current_level = 5
	_hide_irrelevant_ui()

	ObjectiveManager.reset()
	ObjectiveManager.add_objective("Jawab telepon")
	ObjectiveManager.add_objective("Coba buka pintu")
	ObjectiveManager.start()
	slow_down_player()
	_connect_interactables()
	play_hp_ringing_loop()

	start_light_flicker()
	play_ambient_loop()

# =====================================================
# HIDE IRRELEVANT UI
# =====================================================
func _hide_irrelevant_ui():
	var scene = get_tree().current_scene

	var pause_menu = scene.find_child("PauseMenu", true, false)
	if pause_menu:
		pause_menu.hide()

	var level2ui = scene.find_child("level2ui", true, false)
	if level2ui:
		level2ui.hide()

	var level4ui = scene.find_child("level4ui", true, false)
	if level4ui:
		level4ui.hide()

	var inventory_ui = scene.find_child("InventoryUI", true, false)
	if inventory_ui:
		inventory_ui.hide()

	# Hide "Kondisi Raka" khusus Chapter 5 - Raka sudah tiada
	var condition_label = scene.find_child("ConditionLabel", true, false)
	if condition_label:
		condition_label.hide()

# =====================================================
# PLAYER SLOWDOWN
# =====================================================
func slow_down_player():
	var player = get_tree().current_scene.get_node_or_null("Level5Ending/Player")
	if player == null:
		print("Player tidak ditemukan, cek path node")
		return
	if "walk_speed" in player:
		player.walk_speed *= 0.3
	if "sprint_speed" in player:
		player.sprint_speed *= 0.3

# =====================================================
# HP RINGING LOOP
# =====================================================
func play_hp_ringing_loop():
	while hp_ringing and is_inside_tree():
		AudioManager.play_sfx("notification")
		await get_tree().create_timer(3.5).timeout

func stop_hp_ringing():
	hp_ringing = false
	AudioManager.stop_sfx()

# =====================================================
# HORROR GLITCH - Light Flicker
# =====================================================
func start_light_flicker():
	var lights = get_tree().current_scene.find_children("*", "OmniLight3D", true, false)

	while flicker_active and is_inside_tree():
		for light in lights:
			if is_instance_valid(light):
				# Energy goyah antara redup dan nyaris mati
				light.light_energy = randf_range(0.1, 0.6)

				# Warna goyah antara merah gelap dan hampir hitam
				var flicker_color = Color(
					randf_range(0.15, 0.35),  # R - merah tetap ada tapi redup
					0.0,                       # G - selalu 0
					0.0,                       # B - selalu 0
					1.0
				)
				light.light_color = flicker_color

		await get_tree().create_timer(randf_range(0.1, 0.4)).timeout

func stop_light_flicker():
	flicker_active = false

# =====================================================
# HORROR GLITCH - Ambient Sound Loop
# =====================================================
func play_ambient_loop():
	if not AudioManager.sfx.has("ch5_ambient_merah"):
		print("Ambient ch5_ambient_merah tidak ditemukan, skip.")
		return

	while ambient_active and is_inside_tree():
		AudioManager.play_sfx("ch5_ambient_merah")

		var duration := 3.0
		if AudioManager.sfx_player.stream:
			duration = AudioManager.sfx_player.stream.get_length()

		await get_tree().create_timer(duration).timeout

func stop_ambient_loop():
	ambient_active = false

# =====================================================
# INTERACTABLE CONNECTION
# =====================================================
func _connect_interactables():
	var objects = get_tree().get_nodes_in_group("interactable")
	print("Level5 found", objects.size(), "interactable objects")
	for obj in objects:
		if obj.interacted.is_connected(_on_interacted):
			continue
		obj.interacted.connect(_on_interacted)

func _on_interacted(item_id: String):
	print("LEVEL5 TERIMA =", item_id)
	match item_id:
		"hp_ch5":
			if not has_tried_hp:
				has_tried_hp = true
				ObjectiveManager.complete_current()
				print("HP tidak merespon - dering tetap lanjut")
		"obat":
			print("Obat GERD diperiksa - Chapter 5")
		"laptop_ch5":
			print("Laptop diperiksa - Chapter 5")
		"pintu_ch5":
			if not has_tried_pintu:
				has_tried_pintu = true
				ObjectiveManager.complete_current()
				print("Pintu dicoba - tangan menembus (Chapter 5)")

	_check_ending_trigger()

# =====================================================
# CHECK & TRIGGER ENDING CUTSCENE
# =====================================================
func _check_ending_trigger():
	if ending_triggered:
		return
	if has_tried_hp and has_tried_pintu:
		ending_triggered = true
		await get_tree().create_timer(2.0).timeout
		_play_ending_cutscene()

# =====================================================
# HELPER - Play voice, sync dialog duration with real audio length
# =====================================================
func _say_voice(key: String, text: String, extra_pause: float = 0.5):
	AudioManager.play_voice_key(key, 5)

	var duration := 3.0
	if AudioManager.voice_player.stream:
		duration = AudioManager.voice_player.stream.get_length()

	if UiManager.dialog_timer:
		UiManager.dialog_timer.wait_time = duration + extra_pause

	UiManager.show_dialog(text)

	await get_tree().create_timer(duration + extra_pause).timeout

# =====================================================
# HELPER - Play sfx & wait for its real duration
# =====================================================
func _play_sfx_and_wait(key: String, extra_pause: float = 0.3):
	AudioManager.play_sfx(key)

	var duration := 1.0
	if AudioManager.sfx_player.stream:
		duration = AudioManager.sfx_player.stream.get_length()

	await get_tree().create_timer(duration + extra_pause).timeout

# =====================================================
# ENDING CUTSCENE
# =====================================================
func _play_ending_cutscene():
	print("=== ENDING CUTSCENE START ===")

	stop_light_flicker()
	stop_ambient_loop()

	var player = get_tree().current_scene.get_node_or_null("Level5Ending/Player")
	if player and player.has_method("set_physics_process"):
		player.set_physics_process(false)

	# STOP dering HP duluan - kasih jeda sunyi sebelum keributan mulai
	stop_hp_ringing()
	await get_tree().create_timer(1.5).timeout

	await _play_sfx_and_wait("ch5_ketuk_pintu")

	await _say_voice("ojol_01", "Woy Keluar Woy, Orderan Fiktif Ya! Keluar Lu! Atas Nama Mas Rakaaaa!!")

	await _say_voice("bapakkos_01", "Ada Apa Ini?")

	await _say_voice("ojol_02", "Ini Pak Penghuninya!! Berani Banget Bikin Orderan Fiktif Ya, Mana Cupu Banget Ga Mau Keluar!!!")

	await _say_voice("bapakkos_02", "Eh Ini Kan Kamar nya Mas Raka, Dari Kemarin Sepertinya Mas Raka Sibuk Banget Ngerjain Skripsi Sampai Mukanya Pucat")

	await _say_voice("ojol_03", "Jangan Jangan Pak… Ayo Buka Pintunya Aja, Bapak Punya Kunci Cadangannya Ngga?")

	await _say_voice("bapakkos_03", "Aduh Bapak Ga Punya")

	await _play_sfx_and_wait("ch5_pintu_jebol")

	await _play_sfx_and_wait("ch5_langkah_masuk")

	await _say_voice("bapakkos_04", "Innalillahi…")

	# Musik ending + fade to black
	AudioManager.play_sfx("ch5_ending_music")
	var transition = get_tree().current_scene.find_child("Transition", true, false)
	if transition and transition.has_method("fade_out"):
		await transition.fade_out(3.0)

	# Tampilkan teks akhir - TIDAK pakai show_dialog biar tidak auto-hide
	if UiManager.dialog_panel and UiManager.dialog_label:
		UiManager.dialog_panel.show()
		UiManager.dialog_label.text = "TAMAT"

	print("=== ENDING CUTSCENE DONE ===")

	# Tunggu beberapa detik, lalu kembali ke main menu
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://scenes/mainmenu/mainmenu.tscn")
