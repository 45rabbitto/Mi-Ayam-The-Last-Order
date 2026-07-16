extends CanvasLayer

# Ambil node sesuai struktur di atas
@onready var dim_background = $ColorRect
@onready var notification_panel = $Panel
@onready var notif_title = $Panel/phonenotif
@onready var beni_message = $Panel/phonenotif/NotifBeni
@onready var continue_button = $Panel/lanjutch3    

func _ready():
	# Jika ada suara notifikasi
	AudioManager.play_sfx("notification_sound")

	# Sembunyikan semua (kecuali background mungkin)
	hide()
	dim_background.show()   # background tetap terlihat saat di-hide? 
	# Lebih aman kita atur di open()

	# State awal (saat di-hide, nanti saat open baru muncul)
	notification_panel.hide()
	notif_title.hide()
	beni_message.hide()
	continue_button.hide()


func open():
	# Tampilkan CanvasLayer
	show()

	# Tampilkan background gelap
	dim_background.show()
	
	# Tampilkan panel dan isinya
	notification_panel.show()
	notif_title.show()
	beni_message.show()
	
	# Tombol lanjut disembunyikan dulu
	continue_button.hide()

	# Beri waktu baca notifikasi (misal 2 detik)
	await get_tree().create_timer(2.0).timeout

	# Tombol lanjut muncul setelah jeda
	continue_button.show()

func _on_lanjutch_3_pressed():
	AudioManager.play_sfx("transition")
	await Transition.fade_out()
	get_tree().change_scene_to_file("res://scenes/storych3/storych3.tscn")
