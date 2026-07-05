extends SubViewport

@onready var holder = $Node3D/ModelHolder

var current_model: Node3D


func load_item(scene: PackedScene) -> void:

	if current_model:
		current_model.queue_free()

	if scene == null:
		push_error("PackedScene kosong.")
		return

	current_model = scene.instantiate()

	holder.add_child(current_model)

	_fit_camera()


func _fit_camera() -> void:

	if current_model == null:
		return

	current_model.position = Vector3.ZERO
	current_model.rotation = Vector3.ZERO
	current_model.scale = Vector3.ONE * 0.4


func get_preview() -> Texture2D:
	return get_texture()
