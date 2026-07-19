extends CanvasLayer

@onready var btn_pesan = $ButtonPesan

var qte_scene = preload("res://scenes/qte_miayam.tscn")
var qte = null


func _ready():
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	hide()

	print("BTN =", btn_pesan)
	print("BTN PATH =", btn_pesan.get_path())

	btn_pesan.pressed.connect(_on_ButtonPesan_pressed)
	
func open():

	show()

	btn_pesan.show()

	print("VISIBLE =", btn_pesan.visible)
	print("DISABLED =", btn_pesan.disabled)
	print("GLOBAL RECT =", btn_pesan.get_global_rect())

	# JANGAN PAUSE DULU
	# get_tree().paused = true

	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func close():

	hide()

	get_tree().paused = false

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		print("MOUSE =", event.position)

func _on_ButtonPesan_pressed():

	print("BUTTON PESAN DIKLIK")

	AudioManager.play_ui("click")

	btn_pesan.hide()

	qte = qte_scene.instantiate()

	print("QTE =", qte)

	add_child(qte)

	qte.qte_success.connect(_on_qte_success)
	qte.qte_failed.connect(_on_qte_failed)

	qte.start_qte()
	
func _on_qte_success():

	print("QTE BERHASIL")

	qte.queue_free()

	close()

	var controller = get_tree().current_scene.get_node_or_null(
		"Level4Controller"
	)

	if controller:

		controller.order_success()


func _on_qte_failed():

	print("QTE GAGAL")

	qte.queue_free()

	btn_pesan.show()

	UiManager.show_notification(
		"Pesanan gagal. Coba lagi."
	)
