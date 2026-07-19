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

	ObjectiveManager.reset()

	ObjectiveManager.add_objective("Kerjakan Skripsi")
	ObjectiveManager.add_objective("Ambil Sendok")
	ObjectiveManager.add_objective("Ambil Kopi Bubuk")
	ObjectiveManager.add_objective("Ambil Dispenser")
	ObjectiveManager.add_objective("Ambil gelas")
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


	print("Current Objective =",
	ObjectiveManager.get_current_objective())
	AudioManager.play_voice_key("raka_01", 3)

	next_chapter_button.hide()
	next_chapter_button.pressed.connect(_on_button_next_level_4_pressed)

	print("Button =", next_chapter_button)

	if next_chapter_button == null:
		print("BUTTON TIDAK DITEMUKAN!")
		return
	
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
	
	print("LEVEL3 TERIMA =", item_id)

	match item_id:

		"laptop_skripsi":
			if skripsi_done:
				return
			qte_context = "skripsi"
			qte_panel.start_qte(4, 12.0) # 12 detik
					
		"sendok":

			if sendok_done:
				return

			sendok_done = true

			Global.show_notification("Sendok diambil")

			ObjectiveManager.complete_current()

		"kopi_bubuk":

			if kopi_bubuk_done:
				return

			kopi_bubuk_done = true

			Global.show_notification("Kopi bubuk diambil")

			ObjectiveManager.complete_current()
			
		"dispenser":

			if dispenser_done:
				return

			dispenser_done = true

			Global.show_notification("Dispenser diambil")

			ObjectiveManager.complete_current()

			Global.show_notification(
				"Sekarang buat kopi di gelas."
			)
			
		"gelas_buat":

			if ObjectiveManager.get_current_objective() != "Ambil gelas":
				return

			start_make_coffee()
			
		"gelas":

			if gelas_done:
				return

			gelas_done = true

			Global.show_notification("Gelas diambil")
			
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
		
		
func start_make_coffee():

	print("MULAI BUAT KOPI")
	print("BUAT KOPI NODE =", buat_kopi)

	if buat_kopi == null:
		print("BUATKOPI NULL")
		return

	AudioManager.play_sfx("ch3_sendok_aduk")

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	await buat_kopi.show_message(
		"Kopi sedang diseduh...",
		2.5
	)

	AudioManager.stop_sfx()

	print("SHOW MESSAGE SELESAI")

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	Global.show_notification("Kopi jadi!")

	AudioManager.play_voice_key("raka_05",3)

	ObjectiveManager.complete_current()
	
# =====================================================
# HP CHAT
# =====================================================

func _on_hp_chat_interact():
	if not chat_beni_shown:
		if not skripsi_done:
			Global.show_notification("Belum ada notif...")
			return

		chat_beni_shown = true
		Global.show_notification('Beni: "Rak, mabar? Bentar aja lah"')
		AudioManager.play_voice_key("beni_01", 3)

		ObjectiveManager.complete_current()
		print("Objective:", ObjectiveManager.get_current_objective())
		return

	if chat_beni_shown and not mabar_done:
		if not kopi_bubuk_done:
			Global.show_notification("Selesaikan kopi dulu...")
			return

		qte_context = "mabar"
		qte_panel.start_qte(5, 10.0)
		return

# =====================================================
# QTE CALLBACKS
# =====================================================

func _on_qte_success():
	match qte_context:
		"skripsi":
			skripsi_done = true
			Global.show_notification("Skripsi dikerjakan...")
			AudioManager.play_voice_key("raka_02", 3)

			ObjectiveManager.complete_current()
			print("Objective:", ObjectiveManager.get_current_objective())

		"mabar":

			print("SEBELUM COMPLETE:", ObjectiveManager.get_current_objective())

			ObjectiveManager.complete_current()

			print("SESUDAH COMPLETE:", ObjectiveManager.get_current_objective())
			
			mabar_done = true

			Global.show_notification('Beni: "Lu belum makan, kan?"')
			AudioManager.play_voice_key("beni_02", 3)
			AudioManager.play_sfx("ch3_mabar_ambient")

			await get_tree().create_timer(2.0).timeout

			Global.show_notification('Raka: "Iya sih, abis ini lah..."')
			AudioManager.play_voice_key("raka_07", 3)

			await get_tree().create_timer(2.0).timeout

			ObjectiveManager.complete_current() # Selesai "Mabar Bareng Beni"

			await get_tree().create_timer(2.0).timeout

			AudioManager.play_voice_key("raka_09", 3)

			await get_tree().create_timer(2.0).timeout

			level_complete()


func _on_qte_failed():
	Global.show_notification("Gagal! Coba lagi...")
	match qte_context:
		"skripsi":
			qte_panel.start_qte(4)
		"mabar":
			qte_panel.start_qte(5)

# =====================================================
# LEVEL COMPLETE
# =====================================================

func level_complete():

	Global.show_notification("Chapter 3 selesai!")

	next_chapter_button.show()
func _on_button_next_level_4_pressed():

	ObjectiveManager.complete_current()

	next_chapter_button.hide()

	Transition.fade_out()

	await get_tree().create_timer(1.0).timeout

	get_tree().change_scene_to_file(
		"res://scenes/level/level_4_order.tscn"
	)
