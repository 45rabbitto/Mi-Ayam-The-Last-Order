extends Area3D

func _ready():
	print("LAPTOP READY")
	add_to_group("interactable")

func get_prompt() -> String:
	return "Periksa Laptop"

func interact(player):

	print("=== LAPTOP INTERACT ===")

	var mesh = find_child("MeshInstance3D", true, false)

	if mesh:
		mesh.visible = false
	else:
		print("MESH TIDAK DITEMUKAN")

	queue_free()
