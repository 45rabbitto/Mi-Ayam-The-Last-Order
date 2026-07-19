extends CharacterBody3D


# ==========================================================
# MOVEMENT
# ==========================================================

@export var walk_speed := 3.0
@export var sprint_speed := 5.0
@export var mouse_sensitivity := 0.002


# ==========================================================
# NODE
# ==========================================================

@onready var head: Node3D = $Head

@onready var camera: Camera3D = $Head/Camera3D

@onready var raycast: RayCast3D = $Head/Camera3D/RayCast3D

@onready var interaction_manager = $InteractionManager


# ==========================================================
# STATE
# ==========================================================

var current_speed := 0.0


# ==========================================================
# READY
# ==========================================================

func _ready() -> void:

	Input.set_mouse_mode(
		Input.MOUSE_MODE_CAPTURED
	)

	print("================================")
	print("PLAYER CONTROLLER READY")
	print("================================")


# ==========================================================
# PHYSICS
# ==========================================================

func _physics_process(
	delta: float
) -> void:

	handle_movement()

	handle_gravity(
		delta
	)

	move_and_slide()


# ==========================================================
# MOVEMENT
# ==========================================================

func handle_movement() -> void:

	var input_dir := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)


	var direction := (
		transform.basis
		* Vector3(
			input_dir.x,
			0,
			input_dir.y
		)
	)


	# ======================================================
	# SPRINT
	# ======================================================

	if Input.is_action_pressed(
		"sprint"
	):

		current_speed = sprint_speed

	else:

		current_speed = walk_speed


	if direction.length() > 0:

		direction = direction.normalized()


		velocity.x = direction.x * current_speed

		velocity.z = direction.z * current_speed

	else:

		velocity.x = move_toward(
			velocity.x,
			0,
			current_speed
		)

		velocity.z = move_toward(
			velocity.z,
			0,
			current_speed
		)


# ==========================================================
# GRAVITY
# ==========================================================

func handle_gravity(
	delta: float
) -> void:

	if not is_on_floor():

		velocity.y -= (
			ProjectSettings
			.get_setting(
				"physics/3d/default_gravity"
			)
			* delta
		)

	else:

		velocity.y = 0


# ==========================================================
# INPUT
# ==========================================================

func _unhandled_input(
	event: InputEvent
) -> void:


	# ======================================================
	# ALT - TOGGLE MOUSE
	# ======================================================

	if event is InputEventKey:

		if event.keycode == KEY_ALT \
		and event.pressed:

			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:

				Input.set_mouse_mode(
					Input.MOUSE_MODE_VISIBLE
				)

			else:

				Input.set_mouse_mode(
					Input.MOUSE_MODE_CAPTURED
				)


	# ======================================================
	# MOUSE LOOK
	# ======================================================

	if event is InputEventMouseMotion:

		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:

			return


		rotate_y(
			-event.relative.x
			* mouse_sensitivity
		)


		head.rotate_x(
			-event.relative.y
			* mouse_sensitivity
		)


		head.rotation.x = clamp(
			head.rotation.x,
			deg_to_rad(-80),
			deg_to_rad(80)
		)


	# ======================================================
	# INVENTORY SLOT
	# ======================================================

	if event.is_action_pressed("slot1"):

		use_inventory_slot(0)


	elif event.is_action_pressed("slot2"):

		use_inventory_slot(1)


	elif event.is_action_pressed("slot3"):

		use_inventory_slot(2)


	elif event.is_action_pressed("slot4"):

		use_inventory_slot(3)


	elif event.is_action_pressed("slot5"):

		use_inventory_slot(4)


	elif event.is_action_pressed("slot6"):

		use_inventory_slot(5)


	elif event.is_action_pressed("slot7"):

		use_inventory_slot(6)


	# ======================================================
	# INTERACTION
	# ======================================================

	if event.is_action_pressed("interact"):

		if interaction_manager:

			interaction_manager.try_interact()


	# ======================================================
	# PAUSE
	# ======================================================

	if event.is_action_pressed("pause"):

		if UiManager:

			UiManager.toggle_pause()


# ==========================================================
# INVENTORY
# ==========================================================

func use_inventory_slot(
	index: int
) -> void:

	print(
		"INVENTORY SLOT : ",
		index + 1
	)


	var inventory_ui = get_tree().get_first_node_in_group(
		"inventory_ui"
	)


	if inventory_ui == null:

		print(
			"INVENTORY UI TIDAK DITEMUKAN"
		)

		return


	inventory_ui.use_slot(
		index
	)
