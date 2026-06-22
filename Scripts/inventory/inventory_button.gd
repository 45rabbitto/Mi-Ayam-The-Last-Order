extends Node

@onready var inventory_ui = $"../InventoryUI"

var opened := false

func toggle():

	opened = !opened
	inventory_ui.visible = opened
