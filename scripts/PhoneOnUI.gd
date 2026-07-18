extends CanvasLayer

@onready var black_screen = $Panel/BlackScreen
@onready var charging_image = $Panel/ChargingImage
@onready var home_screen = $Panel/HomeScreen
@onready var continue_button = $Panel/ContinueButton


func _ready():
	
	AudioManager.play_bgm("phone")

	AudioManager.play_sfx("charging")

	hide()

	black_screen.show()
	charging_image.hide()
	home_screen.hide()
	continue_button.hide()


func open():

	show()

	# HP masih mati
	black_screen.show()
	charging_image.show()
	home_screen.hide()
	continue_button.hide()

	# Charging 5 detik
	await get_tree().create_timer(3.0).timeout
	
	AudioManager.stop_sfx()

	# HP menyala
	black_screen.hide()
	charging_image.hide()
	home_screen.show()

	# Tunggu sedikit biar efeknya lebih natural
	await get_tree().create_timer(1.0).timeout

	continue_button.show()

	AudioManager.play_voice_key("missed_call",1)
	
func _on_continue_button_pressed():

	AudioManager.play_sfx("transition")

	await Transition.fade_out()

	# ======================================================
	# RESET INVENTORY SEBELUM CHAPTER 2
	# ======================================================

	print("================================")
	print("PINDAH KE CHAPTER 2")
	print("================================")

	print(
		"INVENTORY SEBELUM CLEAR : ",
		InventoryManager.get_items()
	)

	InventoryManager.clear_inventory()

	print(
		"INVENTORY SETELAH CLEAR : ",
		InventoryManager.get_items()
	)


	# ======================================================
	# LOAD CHAPTER 2
	# ======================================================

	GameManager.current_chapter = 2

	LevelManager.load_level(2)
