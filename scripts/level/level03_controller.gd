extends Node3D

# =====================================================
# STATE FLAGS
# =====================================================

var skripsi_done := false

# Sequence bikin kopi (disederhanakan: 4 item, urutan bebas)
var gelas_done := false
var kopi_bubuk_done := false
var air_panas_done := false
var sendok_done := false

var chat_beni_shown := false      # trigger pertama: "Rak, mabar?"
var mabar_done := false           # trigger kedua: setelah "ngobrol" / QTE mabar
var mi_ayam_ordered := false      # akhir chapter

# =====================================================
# QTE
# =====================================================

@onready var qte_panel = $QTEPanel
var qte_context: String = ""      # "skripsi" atau "mabar" -- nandain QTE mana yang lagi jalan


# =====================================================
# READY
# =====================================================

func _ready():
	print("=== LEVEL 3 (FLASHBACK) READY ===")

	ObjectiveManager.reset()

	ObjectiveManager.add_objective("Kerjakan Skripsi")
	ObjectiveManager.add_objective("Buat Kopi")
	ObjectiveManager.add_objective("Balas Chat Beni")
	ObjectiveManager.add_objective("Mabar Bareng Beni")
	ObjectiveManager.add_objective("Pesan Mi Ayam")

	AudioManager.play_bgm("chapter1_room")  # ganti ke bgm chapter3 kalau sudah ada di AudioManager

	ObjectiveManager.start()

	_connect_interactables()

	qte_panel.qte_success.connect(_on_qte_success)
	qte_panel.qte_failed.connect(_on_qte_failed)

	print("Current Objective =", ObjectiveManager.get_current_objective())

	# Voice opening chapter 3
	AudioManager.play_voice_key("raka_01", 3)  # "Oke fokus skripsi dulu..."


func _connect_interactables():
	var objects = get_tree().get_nodes_in_group("interactable")
	print("Found", objects.size(), "interactable objects")

	for obj in objects:
		if obj.interacted.is_connected(on_item_collected):
			continue
		obj.interacted.connect(on_item_collected)


# =====================================================
# ITEM INTERACTION
# =====================================================

func on_item_collected(item_id: String):
	match item_id:

		# -------------------------------------------------
		# STEP 1: SKRIPSI -> sekarang trigger QTE dulu
		# -------------------------------------------------
		"laptop_skripsi":
			if skripsi_done:
				return
			qte_context = "skripsi"
			qte_panel.start_qte(4)

		# -------------------------------------------------
		# STEP 2: BIKIN KOPI (4 item, urutan bebas)
		# -------------------------------------------------
		"gelas":
			if gelas_done:
				return
			gelas_done = true
			Global.show_notification("Gelas diambil")
			_check_kopi_complete()

		"kopi_bubuk":
			if kopi_bubuk_done:
				return
			kopi_bubuk_done = true
			Global.show_notification("Kopi bubuk dituang")
			AudioManager.play_sfx("ch3_kopi_tuang")
			_check_kopi_complete()

		"air_panas":
			if air_panas_done:
				return
			air_panas_done = true
			Global.show_notification("Air panas dituang")
			_check_kopi_complete()

		"sendok":
			if sendok_done:
				return
			sendok_done = true
			Global.show_notification("Kopi diaduk")
			AudioManager.play_sfx("ch3_sendok_aduk")
			_check_kopi_complete()

		# -------------------------------------------------
		# STEP 3 & 4: HP / CHAT BENI (diklik berkali-kali, beda state)
		# -------------------------------------------------
		"hp_chat":
			_on_hp_chat_interact()

	# -------------------------------------------------
	# STEP 5: PESAN MI AYAM (dipanggil manual dari UI
	# prompt "Pesan mi ayam?" setelah mabar_done true --
	# lihat fungsi order_mi_ayam() di bawah)
	# -------------------------------------------------


func _check_kopi_complete():
	if gelas_done and kopi_bubuk_done and air_panas_done and sendok_done:
		Global.show_notification("Kopi jadi!")
		ObjectiveManager.complete_current()
		print("Objective:", ObjectiveManager.get_current_objective())


func _on_hp_chat_interact():

	# Klik HP pertama kali: hanya boleh setelah skripsi selesai
	if not chat_beni_shown:
		if not skripsi_done:
			Global.show_notification("Belum ada notif...")
			return

		chat_beni_shown = true
		Global.show_notification('Beni: "Rak, mabar?"')
		AudioManager.play_voice_key("beni_01", 3)

		ObjectiveManager.complete_current()
		print("Objective:", ObjectiveManager.get_current_objective())
		return

	if chat_beni_shown and not mabar_done:
		if not kopi_bubuk_done:  # pastikan kopi udah jadi sebelum mabar
			Global.show_notification("Selesaikan kopi dulu...")
			return

		qte_context = "mabar"
		qte_panel.start_qte(5)
		return

	if mabar_done and not mi_ayam_ordered:
		order_mi_ayam()


# =====================================================
# QTE CALLBACKS
# =====================================================

func _on_qte_success():
	match qte_context:
		"skripsi":
			skripsi_done = true
			Global.show_notification("Skripsi dikerjakan...")
			AudioManager.play_voice_key("raka_02", 3)  # "Dikit lagi... ayo..."
		

			ObjectiveManager.complete_current()
			print("Objective:", ObjectiveManager.get_current_objective())

		"mabar":
			mabar_done = true
			Global.show_notification('Beni: "Lu belum makan, kan?"')
			AudioManager.play_voice_key("beni_02", 3)
			AudioManager.play_sfx("ch3_mabar_ambient")

			ObjectiveManager.complete_current()
			print("Objective:", ObjectiveManager.get_current_objective())

			AudioManager.play_voice_key("raka_09", 3)  # "Yaudah, pesen mi ayam aja..."

	qte_context = ""


func _on_qte_failed():
	Global.show_notification("Gagal! Coba lagi...")
	match qte_context:
		"skripsi":
			qte_panel.start_qte(4)
		"mabar":
			qte_panel.start_qte(5)


# =====================================================
# STEP 5: PESAN MI AYAM (akhir chapter 3)
# =====================================================

func order_mi_ayam():
	if mi_ayam_ordered:
		return
	mi_ayam_ordered = true

	Global.show_notification("Mi ayam dipesan...")
	ObjectiveManager.complete_current()

	level_complete()


# =====================================================
# LEVEL COMPLETE -> LANJUT CHAPTER 4
# =====================================================

func level_complete():
	Global.show_notification("Chapter 3 selesai!")
	await get_tree().create_timer(2.0).timeout
	get_tree().change_scene_to_file(
		"res://scenes/level/level_3_flashback.tscn"  # ganti ke scene chapter 4 kalau sudah dipisah
	)
