extends Node3D

var phone_opened := false
var order_finished := false

@onready var phonegrab = get_tree().current_scene.get_node_or_null(
	"Hud/Phonegrab"
)

func _ready():

	print("===== MASUK LEVEL 4 =====")

	Global.current_level = 4
	InventoryManager.clear_inventory()
	# ===============================
	# OBJECTIVE
	# ===============================

	ObjectiveManager.reset()

	ObjectiveManager.add_objective("Buka HP")

	ObjectiveManager.add_objective("Pesan Mi Ayam")

	ObjectiveManager.add_objective("Lanjut Chapter 5")

	ObjectiveManager.start()

	# HP Grab jangan muncul dulu
	if phonegrab:
		phonegrab.hide()

	# Tombol chapter 5 juga sembunyi
	var btn = get_tree().current_scene.get_node_or_null(
		"Hud/level4ui/ButtonNextChapter5"
	)

	if btn:
		btn.hide()

	_connect_interactable()
	
func _connect_interactable():

	var objects = get_tree().get_nodes_in_group("interactable")

	for obj in objects:

		if obj.interacted.is_connected(_on_interacted):
			
			continue

		obj.interacted.connect(_on_interacted)
		
func _on_interacted(item_id:String):

	match item_id:

		"phone":

			if phone_opened:
				return

			phone_opened = true

			ObjectiveManager.complete_current()

			open_phone()
			
func open_phone():

	print("BUKA PHONE")

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	get_tree().paused = true

	phonegrab.show()

	phonegrab.open()
	
func order_success():

	if order_finished:
		return

	order_finished = true

	ObjectiveManager.complete_current()

	UiManager.show_notification(
		"Mi Ayam berhasil dipesan."
	)

	await get_tree().create_timer(5).timeout

	show_next_button()
	
func show_next_button():

	ObjectiveManager.complete_current()

	var btn = get_tree().current_scene.get_node_or_null(
		"Hud/level4ui/ButtonNextChapter5"
	)

	if btn:

		btn.show()
		
func close_phone():

	get_tree().paused = false

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	phonegrab.hide()
