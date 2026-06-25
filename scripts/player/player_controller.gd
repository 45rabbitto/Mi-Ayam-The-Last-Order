extends CharacterBody3D

@export var walk_speed := 4.0
@export var sprint_speed := 7.0
@export var mouse_sensitivity := 0.003

@onready var head = $Head
@onready var raycast = $Head/RayCast3D

var move_input := Vector2.ZERO
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	add_to_group("player")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	
	
	handle_movement(delta)
	handle_gravity(delta)

	move_and_slide()

func handle_movement(delta):

	var input_dir = Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
		"move_backward"
	)
	

	if move_input != Vector2.ZERO:
		input_dir = move_input

	var speed = walk_speed

	if Input.is_action_pressed("sprint"):
		speed = sprint_speed

	var direction = Vector3.ZERO

	var forward = -transform.basis.z
	var right = transform.basis.x

	direction += forward * input_dir.y
	direction += right * input_dir.x

	direction = direction.normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

func handle_gravity(delta):

	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0

func _input(event):
	print("ADA INPUT")

	if event is InputEventMouseMotion:
		print("E DITEKAN")
		var interaction_manager = $InteractionManager
		
		rotate_y(
			-event.relative.x *
			mouse_sensitivity
		)

		head.rotate_x(
			-event.relative.y *
			mouse_sensitivity
		)

		head.rotation.x = clamp(
			head.rotation.x,
			deg_to_rad(-80),
			deg_to_rad(80)
		)

	if event.is_action_pressed("interact"):

		var interaction_manager = $InteractionManager
		print("Manager =", interaction_manager)
		if interaction_manager:
			interaction_manager.try_interact()

func set_move_input(value: Vector2):
	move_input = value

func set_joystick_input(value: Vector2):
	move_input = value

func rotate_camera(x_amount: float, y_amount: float):

	rotate_y(
		-x_amount *
		mouse_sensitivity
	)

	head.rotate_x(
		-y_amount *
		mouse_sensitivity
	)

	head.rotation.x = clamp(
		head.rotation.x,
		deg_to_rad(-80),
		deg_to_rad(80)
	)
