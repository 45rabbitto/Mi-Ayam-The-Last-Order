extends StaticBody3D
class_name Interactable

# =========================
# INTERACTION DATA
# =========================

@export var object_name : String = "Object"

@export_multiline var inspect_text : String = ""

@export var interaction_text : String = "Interact"

@export var can_interact : bool = true

@export var highlight_on_focus : bool = true


# =========================
# VISUAL
# =========================

@onready var mesh : MeshInstance3D = get_node_or_null("MeshInstance3D")

var original_material : Material
var highlight_material : StandardMaterial3D


# =========================
# READY
# =========================

func _ready():

	if mesh:

		original_material = mesh.material_override

		highlight_material = StandardMaterial3D.new()

		highlight_material.albedo_color = Color(1,1,0)

		highlight_material.emission_enabled = true

		highlight_material.emission = Color(1,1,0)

		highlight_material.emission_energy_multiplier = 2.0


# =========================
# FOCUS
# =========================

func focus():

	if not highlight_on_focus:
		return

	if mesh:
		mesh.material_override = highlight_material


func unfocus():

	if mesh:
		mesh.material_override = original_material


# =========================
# MAIN INTERACTION
# =========================

func interact(player):

	if not can_interact:
		return

	print("Interacting with: ", object_name)


# =========================
# INSPECT
# =========================

func inspect():

	if inspect_text == "":
		return

	if UiManager:

		UiManager.notify(inspect_text)


# =========================
# ITEM MATCHING
# =========================

func use_item(item_name : String):

	pass


# =========================
# PUZZLE OBJECT
# =========================

func place_object():

	pass


# =========================
# NARRATIVE TRIGGER
# =========================

func trigger_story():

	pass
