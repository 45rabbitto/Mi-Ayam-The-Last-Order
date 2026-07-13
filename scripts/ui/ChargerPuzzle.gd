extends CanvasLayer

signal puzzle_finished

@onready var progress = $Panel/Progress

@onready var usb_a = $Panel/USBContainer/USB_A
@onready var usb_c = $Panel/USBContainer/USB_C
@onready var micro_usb = $Panel/USBContainer/MICRO_USB
@onready var usb_ip = $Panel/USBContainer/USB_IP

var sequence = []
var player_sequence = []
var can_click = false

const MAX_SEQUENCE = 5

func _ready():

	hide()

	randomize()

func generate_sequence():

	sequence.clear()

	for i in range(MAX_SEQUENCE):
		sequence.append(randi() % 4)

	print(sequence)
	
func start():

	AudioManager.play_bgm("puzzle")

	show()

	generate_sequence()

	progress.text = "Perhatikan urutan lampu,\nlalu ulangi urutannya."

	await get_tree().create_timer(2.5).timeout

	progress.text = "Mulai dalam 3..."

	await get_tree().create_timer(1.0).timeout

	progress.text = "Mulai dalam 2..."

	await get_tree().create_timer(1.0).timeout

	progress.text = "Mulai dalam 1..."

	await get_tree().create_timer(1.0).timeout

	play_sequence()
	
	
func play_sequence():

	progress.text = "Menghafal..."

	for value in sequence:

		var button = get_button(value)

		button.modulate = Color(2,2,2)

		await get_tree().create_timer(0.8).timeout

		button.modulate = Color.WHITE

		await get_tree().create_timer(0.4).timeout

	progress.text = "Giliranmu!"
	
	player_sequence.clear()
	can_click = true
	
func get_button(index):

	match index:

		0:
			return usb_a

		1:
			return usb_c

		2:
			return micro_usb

		3:
			return usb_ip

	return null
	
func press_usb(index):
	
	AudioManager.play_ui("click")

	if !can_click:
		return

	player_sequence.append(index)

	check_answer()
	
func check_answer():

	var current = player_sequence.size() - 1

	if player_sequence[current] != sequence[current]:

		can_click = false

		AudioManager.play_sfx("puzzle_fail")

		progress.text = "❌ Salah!"

		print("SALAH!")

		await get_tree().create_timer(1.0).timeout

		player_sequence.clear()

		play_sequence()

		return

	if player_sequence.size() == sequence.size():

		can_click = false

		AudioManager.play_sfx("puzzle_success")
		
		progress.text = "✅ Berhasil!"

		print("BERHASIL!")

		await get_tree().create_timer(1.0).timeout

		puzzle_finished.emit()

		queue_free()
		
		
func _on_usb_a_pressed():
	
	AudioManager.play_ui("click")
	press_usb(0)


func _on_usb_c_pressed():
	
	AudioManager.play_ui("click")
	press_usb(1)


func _on_micro_usb_pressed():
	
	AudioManager.play_ui("click")
	press_usb(2)

func _on_usb_ip_pressed():
	
	AudioManager.play_ui("click")
	press_usb(3)


func _on_close_button_pressed() -> void:
	
	AudioManager.play_ui("click")
	pass # Replace with function body.
	
