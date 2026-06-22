extends Control

@export var max_distance := 80.0

@onready var base = $Base
@onready var knob = $Knob

var dragging := false
var output := Vector2.ZERO

var center := Vector2.ZERO
var player

func _ready():

	center = base.position + base.size / 2

	knob.position = center - knob.size / 2

	player = get_tree().current_scene.get_node("Player")

func _process(delta):

	if dragging:

		update_knob(
			get_global_mouse_position()
		)

	if player:

		player.set_move_input(
	Vector2(
		output.x,
		-output.y
	)
)

func _input(event):

	if event is InputEventMouseButton:

		if event.button_index == MOUSE_BUTTON_LEFT:

			if event.pressed:

				var rect = Rect2(
					base.global_position,
					base.size
				)

				if rect.has_point(event.position):

					dragging = true

			else:

				dragging = false
				output = Vector2.ZERO

				reset_knob()

func update_knob(mouse_pos):

	var dir = mouse_pos - (
		base.global_position +
		base.size / 2
	)

	if dir.length() > max_distance:

		dir = dir.normalized() * max_distance

	output = dir / max_distance

	print(output)

	knob.position = (
		center +
		dir -
		knob.size / 2
	)

func reset_knob():

	knob.position = (
		center -
		knob.size / 2
	)
