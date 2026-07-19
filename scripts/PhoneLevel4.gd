extends Area3D

signal interacted(item_id)

@export var item_id := "phone"

func _ready():
	add_to_group("interactable")

func interact():
	print("HP DIKLIK")
	interacted.emit(item_id)
