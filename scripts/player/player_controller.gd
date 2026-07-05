extends CharacterBody3D

@export var walk_speed := 4.0
@export var sprint_speed := 7.0
@export var mouse_sensitivity := 0.003

@onready var interaction_manager = get_node("InteractionManager")

@onready var head = $Head
@onready var raycast = $Head/Camera3D/RayCast3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


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

	var speed = walk_speed
	if Input.is_action_pressed("sprint"):
		speed = sprint_speed

	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	velocity.x = direction.x * speed
	velocity.z = direction.z * speed


func handle_gravity(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		velocity.y = 0


func _unhandled_input(event):

	# MOUSE LOOK
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-80), deg_to_rad(80))

	# INTERACT
	if event.is_action_pressed("interact"):
		interaction_manager.try_interact()

	# PAUSE
	if event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		$CanvasLayer/PauseMenu.visible = get_tree().paused
