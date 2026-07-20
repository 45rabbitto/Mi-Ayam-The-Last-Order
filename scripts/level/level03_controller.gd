extends Node3D

# =====================================================
# STATE FLAGS
# =====================================================

var skripsi_done := false

var gelas_done := false
var kopi_bubuk_done := false
var dispenser_done := false
var sendok_done := false

var can_make_coffee := false

var chat_beni_shown := false
var mabar_done := false


# =====================================================
# QTE
# =====================================================

@onready var qte_panel = $QTEPanel
var qte_context: String = ""


# =====================================================
# BUAT KOPI (black screen "sedang diseduh")
# =====================================================

@onready var buat_kopi = $BuatKopi


# =====================================================
# NEXT CHAPTER BUTTON
# =====================================================

@onready var next_chapter_button = $Hud/level3ui/ButtonNextLevel4


# =====================================================
# READY
# =====================================================

func _ready():

	print("=== LEVEL 3 (FLASHBACK) READY ===")

	GameManager.current_chapter = 3
	LevelManager.current_level = 3
	Global.current_level = 3

	GameManager.save_game()

	ObjectiveManager.reset()

	ObjectiveManager.add_objective("Kerjakan Skripsi")
	ObjectiveManager.add_objective("Raka terasa kantuk")
	ObjectiveManager.add_objective("Ambil Sendok")
	ObjectiveManager.add_objective("Ambil Kopi Bubuk")
	ObjectiveManager.add_objective("Ambil Dispenser")
	ObjectiveManager.add_objective("Masukkan bahan kopi ke gelas")
	ObjectiveManager.add_objective("Balas Chat Beni")
	ObjectiveManager.add_objective("Mabar Bareng Beni")
	ObjectiveManager.add_objective("Lanjut ke Level 4")


	AudioManager.play_bgm("chapter1_room")

	ObjectiveManager.start()


	if Global.kopi_finished:

		Global.kopi_finished = false

		Global.show_notification("Kopi jadi!")

		ObjectiveManager.complete_current()


	_connect_interactables()


	qte_panel.qte_success.connect(_on_qte_success)
	qte_panel.qte_failed.connect(_on_qte_failed)


	print(
		"Current Objective =",
		ObjectiveManager.get_current_objective()
	)


	_say(
		"raka_01",
		'Raka: "Oke fokus skripsi dulu..."'
	)


	next_chapter_button.hide()

	next_chapter_button.pressed.connect(
		_on_button_next_level_4_pressed
	)


	print("Button =", next_chapter_button)


	if next_chapter_button == null:

		print("BUTTON TIDAK DITEMUKAN!")

		return


# =====================================================
# HELPER - Voice + Popup dengan durasi sinkron
# =====================================================

func _say(
	key: String,
	text: String,
	extra_pause: float = 0.5
) -> void:

	AudioManager.play_voice_key(key, 3)

	var duration := 2.0

	if AudioManager.voice_player.stream:

		duration = AudioManager.voice_player.stream.get_length()


	if UiManager.dialog_timer:

		UiManager.dialog_timer.wait_time = duration + extra_pause


	UiManager.show_dialog(text)


	await get_tree().create_timer(
		duration + extra_pause
	).timeout


# =====================================================
# CONNECT INTERACTABLES
# =====================================================

func _connect_interactables():

	var objects = get_tree().get_nodes_in_group("interactable")

	print(
		"Found",
		objects.size(),
		"interactable objects"
	)


	for obj in objects:

		if obj.interacted.is_connected(on_item_collected):

			continue


		obj.interacted.connect(on_item_collected)


# =====================================================
# ITEM INTERACTION
# =====================================================

func on_item_collected(item_id: String):

	print("LEVEL3 TERIMA =", item_id)


	match item_id:


		# =================================================
		# LAPTOP SKRIPSI
		# =================================================

		"laptop_skripsi":

			if skripsi_done:

				return


			if ObjectiveManager.get_current_objective() != "Kerjakan Skripsi":

				Global.show_notification(
					"Belum waktunya mengerjakan skripsi."
				)

				return


			qte_context = "skripsi"

			qte_panel.start_qte(
				4,
				12.0
			)


		# =================================================
		# SENDOK
		# =================================================

		"sendok":

			if ObjectiveManager.get_current_objective() != "Ambil Sendok":

				Global.show_notification(
					"Belum waktunya mengambil sendok."
				)

				return


			if sendok_done:

				return


			sendok_done = true


			Global.show_notification(
				"Sendok diambil"
			)


			ObjectiveManager.complete_current()


		# =================================================
		# KOPI BUBUK
		# =================================================

		"kopi_bubuk":

			if kopi_bubuk_done:

				return


			kopi_bubuk_done = true


			Global.show_notification(
				"Kopi bubuk diambil"
			)


			ObjectiveManager.complete_current()


		# =================================================
		# DISPENSER
		# =================================================

		"dispenser":

			if dispenser_done:

				return


			dispenser_done = true


			Global.show_notification(
				"Dispenser diambil"
			)


			ObjectiveManager.complete_current()


			_check_kopi_complete()


			Global.show_notification(
				"Sekarang buat kopi di gelas."
			)


		# =================================================
		# GELAS BUAT KOPI
		# =================================================

		"gelas_buat":

			if ObjectiveManager.get_current_objective() != \
			"Masukkan bahan kopi ke gelas":

				Global.show_notification(
					"Belum bisa membuat kopi."
				)

				return


			if not can_make_coffee:

				Global.show_notification(
					"Ambil semua bahan kopi terlebih dahulu."
				)

				return


			start_make_coffee()


		# =================================================
		# GELAS
		# =================================================

		"gelas":

			if gelas_done:

				return


			gelas_done = true


			Global.show_notification(
				"Gelas diambil"
			)


		# =================================================
		# HP CHAT
		# =================================================

		"hp_chat":

			_on_hp_chat_interact()


# =====================================================
# CEK KOPI SELESAI
# =====================================================

func _check_kopi_complete():

	if kopi_bubuk_done \
	and dispenser_done \
	and sendok_done:

		can_make_coffee = true


		Global.show_notification(
			"Klik gelas untuk membuat kopi."
		)


# =====================================================
# BUAT KOPI
# =====================================================

func start_make_coffee():

	print("MULAI BUAT KOPI")

	print(
		"BUAT KOPI NODE =",
		buat_kopi
	)


	if buat_kopi == null:

		print("BUATKOPI NULL")

		return


	AudioManager.play_sfx(
		"ch3_sendok_aduk"
	)


	Input.set_mouse_mode(
		Input.MOUSE_MODE_VISIBLE
	)


	await buat_kopi.show_message(
		"Kopi sedang diseduh...",
		2.5
	)


	AudioManager.stop_sfx()


	print("SHOW MESSAGE SELESAI")


	Input.set_mouse_mode(
		Input.MOUSE_MODE_CAPTURED
	)


	_say(
		"raka_05",
		'Raka: "Kopi dulu biar melek..."'
	)


	ObjectiveManager.complete_current()


# =====================================================
# HP CHAT
# =====================================================

func _on_hp_chat_interact():

	if not chat_beni_shown:

		if not skripsi_done:

			Global.show_notification(
				"Belum ada notif..."
			)

			return


		chat_beni_shown = true


		_say(
			"beni_01",
			'Beni: "Rak, mabar? Bentar aja lah"'
		)


		ObjectiveManager.complete_current()


		print(
			"Objective:",
			ObjectiveManager.get_current_objective()
		)


		return


	if chat_beni_shown and not mabar_done:

		if not kopi_bubuk_done:

			Global.show_notification(
				"Selesaikan kopi dulu..."
			)

			return


		AudioManager.play_sfx(
			"ch3_mabar_ambient"
		)


		qte_context = "mabar"


		qte_panel.start_qte(
			5,
			10.0
		)


# =====================================================
# QTE CALLBACKS
# =====================================================

func _on_qte_success():

	match qte_context:


		# =================================================
		# SKRIPSI
		# =================================================

		"skripsi":

			skripsi_done = true


			# QTE SELESAI
			# LANGSUNG GANTI OBJECTIVE
			ObjectiveManager.complete_current()


			print(
				"OBJECTIVE SEKARANG =",
				ObjectiveManager.get_current_objective()
			)


			await _say(
				"raka_02",
				'Raka: "Dikit lagi... ayo..."'
			)


			await _say(
				"raka_03",
				'Raka: "Aduh... ngantuk banget..."'
			)


			Global.show_notification(
				"Raka terasa kantuk."
			)


			# SELESAI OBJECTIVE RAKA NGANTUK
			# LANGSUNG KE AMBIL SENDOK
			ObjectiveManager.complete_current()


			print(
				"OBJECTIVE SEKARANG =",
				ObjectiveManager.get_current_objective()
			)


		# =================================================
		# MABAR
		# =================================================

		"mabar":

			print(
				"SEBELUM COMPLETE:",
				ObjectiveManager.get_current_objective()
			)


			ObjectiveManager.complete_current()


			print(
				"SESUDAH COMPLETE:",
				ObjectiveManager.get_current_objective()
			)


			mabar_done = true


			await _say(
				"beni_02",
				'Beni: "Lu belum makan, kan?"'
			)


			await _say(
				"raka_07",
				'Raka: "Iya sih, abis ini lah..."'
			)


			ObjectiveManager.complete_current()


			await _say(
				"raka_09",
				'Raka: "Yaudah, pesen mi ayam aja..."'
			)


			level_complete()


# =====================================================
# QTE FAILED
# =====================================================

func _on_qte_failed():

	Global.show_notification(
		"Gagal! Coba lagi..."
	)


	match qte_context:

		"skripsi":

			qte_panel.start_qte(4)


		"mabar":

			qte_panel.start_qte(5)


# =====================================================
# LEVEL COMPLETE
# =====================================================

func level_complete():

	Global.show_notification(
		"Chapter 3 selesai!"
	)


	next_chapter_button.show()


# =====================================================
# BUTTON NEXT LEVEL 4
# =====================================================

func _on_button_next_level_4_pressed():

	ObjectiveManager.complete_current()


	next_chapter_button.hide()


	await Transition.fade_out()


	GameManager.load_chapter(4)
