extends CanvasLayer

signal qte_success
signal qte_failed

@onready var top_row: HBoxContainer = $TopRow
@onready var bottom_row: HBoxContainer = $BottomRow

const LETTER_POOL := "BCEFGHIJKLNOPQRTUVXYZ"
const BOX_COUNT := 5

var letters: Array[String] = []
var current_index := 0

var rounds_required := 3
var rounds_done := 0

var time_limit := 12.0
var timer: Timer


func _ready():
	hide()
	offset = get_viewport().get_visible_rect().size / 2

	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_time_out)
	add_child(timer)


func start_qte(required_rounds: int = 4, time: float = 8.0):

	rounds_required = required_rounds
	rounds_done = 0
	time_limit = time

	show()

	_start_round()

func _start_round():

	print("SOAL BARU")

	current_index = 0
	letters.clear()

	for i in BOX_COUNT:
		letters.append(LETTER_POOL[randi() % LETTER_POOL.length()])

	for i in range(top_row.get_child_count()):
		var lbl: Label = top_row.get_child(i)
		lbl.text = letters[i]
		lbl.add_theme_color_override("font_color", Color.WHITE)

	for i in range(bottom_row.get_child_count()):
		var lbl: Label = bottom_row.get_child(i)
		lbl.text = ""
		lbl.add_theme_color_override("font_color", Color.WHITE)

	timer.start(time_limit)
		
		
func _unhandled_input(event):

	if !visible:
		return

	if event is InputEventKey and event.pressed and !event.echo:

		var key_pressed := OS.get_keycode_string(event.keycode)
		print("KEY =", key_pressed)
		print("INDEX =", current_index)
		print("TARGET =", letters[current_index])

		if key_pressed.length() != 1:
			return

		var top_label: Label = top_row.get_child(current_index)

		if key_pressed == letters[current_index]:

			AudioManager.play_ui("click")

			top_label.add_theme_color_override("font_color", Color.GREEN)

			current_index += 1

			if current_index >= BOX_COUNT:
				print("ROUND SELESAI")
				_finish_round(true)

		else:

			top_label.add_theme_color_override("font_color", Color.RED)
func _finish_round(success: bool):

	timer.stop()

	if success:

		rounds_done += 1

		if rounds_done >= rounds_required:

			_finish_all(true)

		else:

			await get_tree().create_timer(0.5).timeout
			_start_round()

	else:

		_finish_all(false)


func _on_time_out():

	_finish_round(false)


func _finish_all(success: bool):

	hide()

	if success:
		qte_success.emit()
	else:
		qte_failed.emit()
