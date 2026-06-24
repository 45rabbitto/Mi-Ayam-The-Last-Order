extends Control

@onready var label = $InteractionLabel

func _ready():
	visible = false

func show_interaction(text:String):

	label.text = "[E] " + text
	visible = true

func hide_interaction():

	visible = false
