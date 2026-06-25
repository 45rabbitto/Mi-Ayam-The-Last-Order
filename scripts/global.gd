extends Area3D
class_name GlobalManager

signal interacted
signal collected

@export var object_name: String = ""
@export_multiline var inspection_text: String = ""
@export var is_quest_item: bool = false
@export var quest_item_name: String = ""

@onready var highlight_mesh = get_node_or_null("HighlightMesh")

var is_in_inventory = false

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

	if highlight_mesh:
		highlight_mesh.visible = false

func _on_mouse_entered():
	if highlight_mesh:
		highlight_mesh.visible = true

	print("Lihat:", object_name)

func _on_mouse_exited():
	if highlight_mesh:
		highlight_mesh.visible = false

func interact():
	if is_in_inventory:
		return

	if is_quest_item:
		add_to_inventory()
	else:
		inspect()

func inspect():
	print(object_name + ": " + inspection_text)

func add_to_inventory():
	is_in_inventory = true

	print("Item didapat:", quest_item_name)

	hide()

	emit_signal("collected")
