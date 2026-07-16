extends Control

signal qte_success
signal qte_failed

@onready var prompt_label: Label = $PromptLabel
@onready var progress_bar: ProgressBar = $ProgressBar

var keys := ["E", "Q", "F", "R"]
var current_key := ""
var steps_required := 4
var steps_done := 0
var time_limit := 2.0
var timer: Timer

func _ready():
	hide()
	timer = Timer.new()
	timer.one_shot = true
	timer.timeout.connect(_on_time_out)
	add_child(timer)

func start_qte(required_steps: int = 4):
	steps_required = required_steps
	steps_done = 0
	progress_bar.max_value = steps_required
	progress_bar.value = 0
	show()
	_next_step()

func _next_step():
	current_key = keys[randi() % keys.size()]
	prompt_label.text = "Tekan %s !" % current_key
	timer.start(time_limit)

func _unhandled_input(event):
	if not visible:
		return

	if event is InputEventKey and event.pressed and not event.echo:
		var key_pressed = OS.get_keycode_string(event.keycode)

		if key_pressed == current_key:
			timer.stop()
			steps_done += 1
			progress_bar.value = steps_done

			if steps_done >= steps_required:
				_finish(true)
			else:
				_next_step()

func _on_time_out():
	_finish(false)

func _finish(success: bool):
	hide()
	if success:
		qte_success.emit()
	else:
		qte_failed.emit()
