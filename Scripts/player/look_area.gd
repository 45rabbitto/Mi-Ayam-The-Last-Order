extends Control

var dragging := false
var player

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _gui_input(event):

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			dragging = event.pressed

	if event is InputEventMouseMotion and dragging:

		if player:
			player.add_look_input(event.relative)
