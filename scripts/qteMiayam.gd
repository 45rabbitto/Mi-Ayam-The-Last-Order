extends CanvasLayer

signal qte_success
signal qte_failed

@onready var black_flash: ColorRect = $BlackFlash
@onready var top_row = $TopRow
@onready var bottom_row = $BottomRow

const WORD := "MIAYAM"
const BOX_COUNT := 6

var letters := []
var current_index := 0

var rounds_required := 5
var rounds_done := 0

var time_limit := 8.0

var timer : Timer
var glitch_timer : Timer

const RANDOM_CHAR = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"

func _ready():

	hide()

	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_timeout)
	add_child(timer)

	glitch_timer = Timer.new()
	glitch_timer.one_shot = false
	glitch_timer.wait_time = 1.0
	glitch_timer.timeout.connect(_do_glitch)
	add_child(glitch_timer)


func start_qte():

	rounds_done = 0

	show()

	glitch_timer.start()

	_start_round()


func _start_round():

	current_index = 0

	letters.clear()

	for c in WORD:
		letters.append(c)

	for i in range(BOX_COUNT):

		top_row.get_child(i).text = letters[i]
		top_row.get_child(i).modulate = Color.WHITE

		bottom_row.get_child(i).text = ""

	timer.start(time_limit)

	glitch_timer.start()


func _unhandled_input(event):

	if !visible:
		return

	if !(event is InputEventKey):
		return

	if !event.pressed or event.echo:
		return

	var key := OS.get_keycode_string(event.keycode)

	if key == " ":
		return

	if current_index >= BOX_COUNT:
		return

	if key == letters[current_index]:

		AudioManager.play_ui("click")

		bottom_row.get_child(current_index).text = key
		top_row.get_child(current_index).modulate = Color.GREEN

		current_index += 1

		if current_index >= BOX_COUNT:
			_finish_round(true)

	else:

		top_row.get_child(current_index).modulate = Color.RED
		_finish_round(false)

func _finish_round(success):

	timer.stop()

	glitch_timer.stop()

	if success:

		rounds_done += 1

		if rounds_done >= rounds_required:

			_finish_all(true)

		else:

			await get_tree().create_timer(0.5).timeout

			_start_round()

	else:

		_finish_all(false)


func _finish_all(success):

	glitch_timer.stop()

	hide()

	if success:
		qte_success.emit()
	else:
		qte_failed.emit()


func _on_timeout():

	_finish_round(false)

func play_glitch():

	AudioManager.play_sfx("glitch")

	for i in range(4):

		black_flash.color.a = randf_range(0.5, 1.0)
		await get_tree().create_timer(randf_range(0.04, 0.08)).timeout

		black_flash.color.a = 0
		await get_tree().create_timer(randf_range(0.03, 0.06)).timeout

func _do_glitch():

	await play_glitch()

	var idx = randi() % BOX_COUNT

	if idx >= current_index:

		top_row.get_child(idx).text = RANDOM_CHAR[randi() % RANDOM_CHAR.length()]

		await get_tree().create_timer(0.08).timeout

		top_row.get_child(idx).text = letters[idx]

	glitch_timer.wait_time = randf_range(0.8, 1.8)
