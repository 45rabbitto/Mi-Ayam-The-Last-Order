extends Area3D

@export var item_name: String = "hp"
@export var display_name: String = "Handphone"

var player_in_range := false

# =========================
# DETECT PLAYER ENTER
# =========================
func _on_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		show_prompt()

# =========================
# DETECT PLAYER EXIT
# =========================
func _on_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		Hud.clear_interaction()

# =========================
# SHOW INTERACTION TEXT
# =========================
func show_prompt():
	Hud.show_interaction("Tekan E untuk mengambil " + display_name)

# =========================
# INPUT INTERACTION
# =========================
func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		interact()

# =========================
# CORE INTERACTION
# =========================
func interact():

	# 1. ADD ITEM KE INVENTORY
	if InventoryManager:
		InventoryManager.add_item(item_name)

	# 2. HUD NOTIFICATION
	Hud.show_notification("Mendapatkan " + display_name + " 📦", 2.0)

	# 3. UPDATE OBJECTIVE (OPSIONAL HORROR STORY)
	Hud.set_objective("Periksa area sekitar")

	# 4. HILANGKAN ITEM
	queue_free()
