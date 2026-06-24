extends Area3D

@export var item_id : String = "hp_mati" # atau "charger"

func _ready():
	self.input_event.connect(_on_click)

func _on_click(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Tambahkan item ke inventory (panggil fungsi di Main)
		get_node("/root/Main").add_item_to_inventory(item_id)
		# Sembunyikan objek setelah diambil
		self.visible = false
