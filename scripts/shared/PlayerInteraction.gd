extends Node3D

@export var camera_node: Camera3D
@export var interaction_range: float = 3.0
@export var interaction_layer: int = 1 << 0

var current_interactable: Interactable = null
var is_interacting: bool = false
var ray_cast: RayCast3D

func _ready():
	# Buat RayCast3D di bawah camera
	ray_cast = RayCast3D.new()
	ray_cast.target_position = Vector3(0, 0, -interaction_range)
	ray_cast.collision_mask = interaction_layer
	camera_node.add_child(ray_cast)

func _process(_delta):

	if is_interacting or get_tree().paused:
		return

	ray_cast.force_raycast_update()

	if ray_cast.is_colliding():

		var hit = ray_cast.get_collider()

		var interactable = hit.get_parent() as Interactable

		if interactable == null and hit.get_parent():
			interactable = hit.get_parent().get_parent() as Interactable

		if interactable:

			if current_interactable != interactable:

				if current_interactable:
					current_interactable.on_hover_exit()

				current_interactable = interactable
				current_interactable.on_hover_enter()

				UiManager.show_hint("E / Klik Kiri")

			if Input.is_action_just_pressed("interact") \
			or Input.is_action_just_pressed("mouse_interact"):

				current_interactable.interact()

		else:

			clear_hover()

	else:

		clear_hover()

func clear_hover():
	if current_interactable:
		current_interactable.on_hover_exit()
		current_interactable = null
		UiManager.hide_hint()
