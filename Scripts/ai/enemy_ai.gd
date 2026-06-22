extends CharacterBody3D

enum State {
	IDLE,
	PATROL,
	CHASE
}

@export var move_speed := 3.0

@onready var nav: NavigationAgent3D = $NavigationAgent3D

var player: Node3D

var state = State.IDLE

func _ready():

	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):

	match state:

		State.IDLE:
			idle_state()

		State.PATROL:
			patrol_state(delta)

		State.CHASE:
			chase_state(delta)

	move_and_slide()

func idle_state():
	pass

func patrol_state(delta):

	if nav.is_navigation_finished():
		return

	var next = nav.get_next_path_position()

	var dir = (
		next - global_position
	).normalized()

	velocity = dir * move_speed

func chase_state(delta):

	if player == null:
		return

	nav.target_position = player.global_position

	var next = nav.get_next_path_position()

	var dir = (
		next - global_position
	).normalized()

	velocity = dir * move_speed * 1.5

func start_chase():

	state = State.CHASE

	Hud.show_notification(
		"Raka sedang mendekat..."
	)

	GlitchFX.set_intensity(50)

func stop_chase():

	state = State.IDLE

	GlitchFX.set_intensity(0)
