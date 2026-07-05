extends Node3D

@export var required_item: String = "charger"
@export var target_item: String = "hp_mati"
@export var use_success_sfx: AudioStream
@export var use_fail_sfx: AudioStream

func _ready():
	# Tambahkan Area3D untuk deteksi klik
	var area = Area3D.new()
	var collision = CollisionShape3D.new()
	var shape = BoxShape3D.new()
	shape.size = Vector3(0.5, 0.5, 0.5)
	collision.shape = shape
	area.add_child(collision)
	add_child(area)
	
	area.input_event.connect(_on_input_event)

func _on_input_event(_camera, event, _position, _normal, _shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		try_use_item()

func try_use_item():
	if InventoryManager.has_item(required_item):
		# Sukses
		if use_success_sfx:
			AudioManager.play_sfx(use_success_sfx)
		
		# Panggil fungsi charge di Level1Controller
		var controller = get_node("/root/Level1/Level1Controller")
		if controller:
			controller.charge_hp()
	else:
		# Gagal
		if use_fail_sfx:
			AudioManager.play_sfx(use_fail_sfx)
		UIManager.show_dialog("Butuh charger untuk menyalakan HP", "")
