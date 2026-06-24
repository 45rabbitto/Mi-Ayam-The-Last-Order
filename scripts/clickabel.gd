extends Area3D

@export var item_name : String = "Nama Objek"
@export var deskripsi : String = "Deskripsi objek ini."

func _ready():
	# Hubungkan sinyal klik
	self.input_event.connect(_on_click)

func _on_click(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# Panggil fungsi di Main/Player untuk menampilkan teks
		get_node("/root/Main").show_text(deskripsi) # Ganti "Main" dengan nama node utama scene kamu
