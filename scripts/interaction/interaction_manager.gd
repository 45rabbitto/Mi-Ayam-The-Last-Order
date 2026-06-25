extends Node3D

@onready var raycast: RayCast3D = $"../Head/RayCast3D"

var current_target = null

func _ready():

	print("InteractionManager Ready")
	print("Raycast =", raycast)

func _process(_delta):

	check_interaction()

# =====================================================
# DETEKSI OBJEK
# =====================================================
func check_interaction():

	if raycast == null:
		return

	if !raycast.is_colliding():
		current_target = null
		Hud.hide_interaction()
		return

	var collider = raycast.get_collider()

	if collider == null:
		current_target = null
		Hud.hide_interaction()
		return

	var target = collider

	# naik ke parent sampai ketemu interactable
	while target != null and !target.is_in_group("interactable"):
		target = target.get_parent()

	if target == null:
		current_target = null
		Hud.hide_interaction()
		return

	if target.is_in_group("player"):
		current_target = null
		Hud.hide_interaction()
		return

	current_target = target

	var prompt = "Interact"

	if current_target.has_method("get_prompt"):
		prompt = current_target.get_prompt()

	Hud.show_interaction("[E] " + prompt)
	
# =====================================================
# INPUT KEYBOARD
# =====================================================

func _input(event):

	if event.is_action_pressed("interact"):

		print("TOMBOL INTERACT")

		try_interact()

# =====================================================
# SUPPORT PLAYER CONTROLLER
# =====================================================

func try_interact():

	print("===== TRY INTERACT =====")
	print("CURRENT TARGET =", current_target)

	perform_interaction()

# =====================================================
# SUPPORT ANDROID BUTTON
# =====================================================

func interact_button_pressed():

	try_interact()

# =====================================================
# EKSEKUSI INTERAKSI
# =====================================================

func perform_interaction():

	print("PERFORM INTERACTION")
	print("CURRENT TARGET =", current_target)

	if current_target == null:

		print("TARGET NULL")
		return

	print("TARGET =", current_target.name)
	print("HAS INTERACT =", current_target.has_method("interact"))

	var player = get_tree().get_first_node_in_group("player")

	print("PLAYER =", player)

	current_target.interact(player)

	print("INTERACT SELESAI")
