extends CharacterBody3D

# ==========================================================
# PLAYER SETTINGS
# ==========================================================

@export var walk_speed: float = 4.0
@export var sprint_speed: float = 7.0
@export var mouse_sensitivity: float = 0.003

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

# ==========================================================
# NODE
# ==========================================================

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var raycast: RayCast3D = $Head/Camera3D/RayCast3D
@onready var interaction_manager = $InteractionManager

# ==========================================================
# READY
# ==========================================================

func _ready():

	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# ==========================================================
# PHYSICS
# ==========================================================

func _physics_process(delta):

	handle_movement()
	handle_gravity(delta)

	move_and_slide()

# ==========================================================
# MOVEMENT
# ==========================================================

func handle_movement():

	var input_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)

	var speed := walk_speed

	if Input.is_action_pressed("sprint"):
		speed = sprint_speed

	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:

		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

	else:

		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

# ==========================================================
# GRAVITY
# ==========================================================

func handle_gravity(delta):

	if !is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

# ==========================================================
# INPUT
# ==========================================================

func _unhandled_input(event):

	# -------------------------
	# Mouse Look
	# -------------------------

	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:

		rotate_y(-event.relative.x * mouse_sensitivity)

		head.rotate_x(-event.relative.y * mouse_sensitivity)

		head.rotation.x = clamp(
			head.rotation.x,
			deg_to_rad(-80),
			deg_to_rad(80)
		)

	# -------------------------
	# Inventory Slot (1-5)
	# -------------------------

	if event is InputEventKey and event.pressed:

		match event.keycode:

			KEY_1:
				InventoryManager.select_slot(0)

			KEY_2:
				InventoryManager.select_slot(1)

			KEY_3:
				InventoryManager.select_slot(2)

			KEY_4:
				InventoryManager.select_slot(3)

			KEY_5:
				InventoryManager.select_slot(4)

	# -------------------------
	# Interact (E)
	# -------------------------

	if event.is_action_pressed("interact"):

		interaction_manager.try_interact()

	# -------------------------
	# Pause
	# -------------------------

	if event.is_action_pressed("pause"):

		get_tree().paused = !get_tree().paused

		if UiManager:

			UiManager.toggle_pause()

		if get_tree().paused:

			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

		else:

			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
