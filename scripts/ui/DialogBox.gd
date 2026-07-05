extends PanelContainer

@onready var label = $Label
var queue = []
var is_showing = false

func _ready():
	visible = false

func show_dialog(text, duration = 3.0):
	queue.append({"text": text, "duration": duration})
	if not is_showing:
		_show_next()

func _show_next():
	if queue.is_empty():
		is_showing = false
		visible = false
		return
	
	is_showing = true
	visible = true
	var item = queue.pop_front()
	label.text = item.text
	await get_tree().create_timer(item.duration).timeout
	_show_next()
