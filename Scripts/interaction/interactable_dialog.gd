extends Node3D
class_name InteractableDialog

@export var dialog_text := "Hello..."

func interact(player):
	print(dialog_text)

func get_prompt():
	return "Talk"
