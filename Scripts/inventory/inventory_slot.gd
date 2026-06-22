extends Button

@onready var icon = $TextureRect

func set_item(item):

	icon.texture = item.icon
