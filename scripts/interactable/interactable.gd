extends Area3D
class_name Interactable

signal interacted(item_id: String)

@export var object_name: String = ""
@export_multiline var inspection_text: String = ""

@export var voice_key: String = ""

@export var is_pickupable: bool = false
@export var item_id: String = ""

@export var chapter: int = 1

@export var highlight_material: Material

var original_material: Material


func get_prompt() -> String:
	return "Tekan E"


func _ready():

	var mesh = get_node_or_null("MeshInstance3D")

	if mesh:
		original_material = mesh.material_override


func interact():

	# Dialog
	if inspection_text != "":
		UiManager.show_dialog(inspection_text)

	# Voice
	if voice_key != "":
		AudioManager.play_voice_key(voice_key, chapter)

	# Pickup Item
	if is_pickupable:

		print("=== PICKUP ===")
		print("Item ID :", item_id)

		var success = InventoryManager.add_item(item_id)

		print("Success :", success)

		if success:

			print("ITEM MASUK INVENTORY")

			UiManager.show_notification(object_name + " diperoleh")

			ObjectiveManager.complete_if_match(item_id)

			interacted.emit(item_id)

			queue_free()

			return

		else:

			print("GAGAL MASUK INVENTORY")

	interacted.emit("")

func show_highlight():

	var mesh = get_node_or_null("MeshInstance3D")

	if mesh == null:
		return

	if highlight_material:
		mesh.material_override = highlight_material


func hide_highlight():

	var mesh = get_node_or_null("MeshInstance3D")

	if mesh == null:
		return

	mesh.material_override = original_material
