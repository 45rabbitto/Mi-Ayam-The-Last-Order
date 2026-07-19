extends Node3D

# =====================================================
# STATE FLAGS
# =====================================================
var hp_ringing := true

# =====================================================
# READY
# =====================================================
func _ready():
	print("PAUSED STATUS: ", get_tree().paused)
	print("=== LEVEL 5 (SETELAH SUNYI) READY ===")

	# Hide UI yang gak relevan buat Chapter 5
	_hide_irrelevant_ui()

	ObjectiveManager.reset()
	ObjectiveManager.add_objective("Jawab telepon")
	ObjectiveManager.add_objective("Pahami apa yang terjadi")
	ObjectiveManager.start()
	slow_down_player()
	_connect_interactables()
	play_hp_ringing_loop()

# =====================================================
# HIDE IRRELEVANT UI
# =====================================================
func _hide_irrelevant_ui():
	var scene = get_tree().current_scene
	print("SCENE ROOT: ", scene.name)

	var pause_menu = scene.find_child("PauseMenu", true, false)
	print("PauseMenu ditemukan? ", pause_menu)
	if pause_menu:
		print("PauseMenu visible SEBELUM hide: ", pause_menu.visible)
		pause_menu.hide()
		print("PauseMenu visible SESUDAH hide: ", pause_menu.visible)

	var level2ui = scene.find_child("level2ui", true, false)
	if level2ui:
		level2ui.hide()

	var level4ui = scene.find_child("level4ui", true, false)
	if level4ui:
		level4ui.hide()

	var inventory_ui = scene.find_child("InventoryUI", true, false)
	if inventory_ui:
		inventory_ui.hide()

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
		await get_tree().create_timer(2.0).timeout

func stop_hp_ringing():
	hp_ringing = false
	AudioManager.stop_sfx()

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
			stop_hp_ringing()
			UiManager.show_notification("...")
			print("HP tidak merespon")
		"obat":
			UiManager.show_notification("Obat GERD... sudah lama habis.")
		"laptop_ch5":
			UiManager.show_notification("Skripsinya... masih di situ. Menunggu yang gak akan datang.")
			print("Laptop diperiksa - Chapter 5")
		"pintu_ch5":
			UiManager.show_notification("Tangan menembus gagang pintu...")
			print("Pintu dicoba - tangan menembus (Chapter 5)")
