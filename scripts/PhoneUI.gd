extends CanvasLayer

@onready var phone_image: TextureRect = $Panel/PhoneImage
@onready var status_label: Label = $Panel/StatusLabel
@onready var turn_on_button: Button = $Panel/TurnOnButton

var phone_off = preload("res://scenes/ui/items/phone_off.png")
var phone_on = preload("res://scenes/ui/items/phone_on.png")

var phone_is_on := false

func _ready():
	add_to_group("phone_ui")
	AudioManager.play_bgm("phone")


	hide()

	print("PhoneUI Ready")

	if phone_image:
		phone_image.texture = phone_off

	if status_label:
		status_label.text = "Status : HP Mati"


func open():
	print("OPEN PHONE UI")

	show()

	print("Visible =", visible)
	print("Panel Visible =", $Panel.visible)
	
func close():
	print("CLOSE DIPANGGIL")
	hide()
	
func _input(event):

	if !visible:
		return

	if event.is_action_pressed("ui_cancel"):
		close()


func _on_CloseButton_pressed():
	
	AudioManager.play_ui("click")
	
	print("BUTTON CLOSE DITEKAN")
	close()

func turn_on_phone():

	AudioManager.play_ui("click")

	if phone_is_on:
		return


	# cek charger
	if !InventoryManager.has_item("charger"):

		UiManager.show_dialog(
			"Aku harus mencari charger dulu."
		)

		return


	# buka puzzle charger
	var puzzle = preload(
		"res://scenes/ui/ChargerPuzzle.tscn"
	).instantiate()


	get_tree().current_scene.add_child(puzzle)


	hide()


	puzzle.start()


	puzzle.puzzle_finished.connect(
		_on_puzzle_finished
	)
		
func _on_puzzle_finished():
	
	ObjectiveManager.complete_current()
	
	hide()

	var phone_on = preload("res://scenes/ui/PhoneOnUI.tscn").instantiate()

	get_tree().current_scene.add_child(phone_on)

	phone_on.open()

	queue_free()

func toggle_phone():

	if visible:
		close()
	else:
		open()

func _unhandled_input(event):

	if !visible:
		return


	if event.is_action_pressed("ui_cancel"):

		close()


	if event.is_action_pressed("turn_on_phone"):

		print("F ditekan - Nyalakan HP")

		turn_on_phone()
