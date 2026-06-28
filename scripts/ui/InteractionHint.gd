extends Label

func _ready():
	visible = false

func show_hint(text):
	text = "[KLIK] " + text
	visible = true

func hide_hint():
	visible = false
