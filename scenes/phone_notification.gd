extends Control

@onready var label: Label = $Panel/Label

var start_pos := Vector2(400, 20)
var end_pos := Vector2(0, 20)

# =========================
# READY
# =========================
func _ready():
	position = start_pos

# =========================
# SHOW NOTIFICATION
# =========================
func show_notification(text: String, duration := 3.0):

	label.text = text

	var tween = get_tree().create_tween()

	# masuk (slide in)
	tween.tween_property(self, "position", end_pos, 0.4)

	await tween.finished

	await get_tree().create_timer(duration).timeout

	# keluar (slide out)
	var tween2 = get_tree().create_tween()
	tween2.tween_property(self, "position", start_pos, 0.4)

	await tween2.finished
