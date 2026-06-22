extends CharacterBody3D

# =========================
# SETTINGS
# =========================
@export var speed: float = 5.0
@export var gravity: float = 9.8
@export var mouse_sensitivity: float = 0.002

# =========================
# NODE REFERENCES
# =========================
@onready var head: Node3D = $Head
@onready var ray: RayCast3D = get_node_or_null("Head/RayCast3D")

var current_interactable = null


# =========================
# READY
# =========================
func _ready() -> void:
	print("RAY =", ray)
	ray.add_exception(self)
	if ray:
		print("Enabled =", ray.enabled)
		print("Target =", ray.target_position)
		
	add_to_group("player")

	# IMPORTANT: lock mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.set_objective("Cari jalan keluar")
		hud.set_crosshair(true)
		hud.set_raka_state("...")


# =========================
# INPUT (MOUSE LOOK)
# =========================
func _input(event: InputEvent) -> void:

	# MOUSE LOOK
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)

		head.rotation.x = clamp(
			head.rotation.x,
			deg_to_rad(-80),
			deg_to_rad(80)
		)

	# INTERACT
	if event.is_action_pressed("interact"):

		print("INTERACT DITEKAN")

		if current_interactable:
			print("TARGET =", current_interactable.name)

		if current_interactable and current_interactable.has_method("interact"):
			current_interactable.interact(self)
# =========================
# PHYSICS
# =========================
func _physics_process(delta: float) -> void:

	handle_movement()
	handle_gravity(delta)
	move_and_slide()

	check_interaction()


# =========================
# MOVEMENT
# =========================
func handle_movement() -> void:

	var input_dir = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)


# =========================
# GRAVITY
# =========================
func handle_gravity(delta: float) -> void:

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0


# =========================
# INTERACTION
# =========================
func check_interaction() -> void:

	if ray == null:
		return

	if ray.is_colliding():

		var obj = ray.get_collider()

		if current_interactable != obj:

			print("COLLIDER:", obj.name)

		current_interactable = obj

	else:

		current_interactable = null

# =========================
# HUD WRAPPERS
# =========================
func show_interaction(text: String) -> void:
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.show_interaction(text)


func hide_interaction() -> void:
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.hide_interaction()


func show_notification(text: String) -> void:
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.show_notification(text)


func set_raka_state(text: String) -> void:
	var hud = get_tree().get_first_node_in_group("hud")
	if hud:
		hud.set_raka_state(text)
