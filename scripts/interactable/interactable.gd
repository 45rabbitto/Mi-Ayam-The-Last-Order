extends StaticBody3D
class_name Interactable

@export var object_name: String = ""
@export var inspection_text: String = ""
@export var is_quest_item: bool = false
@export var quest_item_name: String = ""
@export var highlight_color: Color = Color.YELLOW

@onready var highlight_mesh = $HighlightMesh
var is_highlighted = false
var is_in_inventory = false

func _ready():
	if highlight_mesh:
		highlight_mesh.visible = false
		highlight_mesh.material_override = StandardMaterial3D.new()
		highlight_mesh.material_override.emission_enabled = true
		highlight_mesh.material_override.emission = highlight_color
		highlight_mesh.material_override.emission_energy = 0.3

func _on_mouse_entered():
	is_highlighted = true
	if highlight_mesh:
		highlight_mesh.visible = true
	# Tampilkan nama objek di UI
	Global.show_interaction_hint(object_name)

func _on_mouse_exited():
	is_highlighted = false
	if highlight_mesh:
		highlight_mesh.visible = false
	Global.hide_interaction_hint()

func interact():
	if is_in_inventory:
		return
	
	if is_quest_item:
		add_to_inventory()
	else:
		inspect()
	
	emit_signal("interacted")

func inspect():
	# Tampilkan dialog Raka
	Global.show_dialog(object_name + ": " + inspection_text)

func add_to_inventory():
	is_in_inventory = true
	Global.inventory.append(quest_item_name)
	visible = false
	Global.show_notification("Item didapat: " + quest_item_name)
	emit_signal("collected")
