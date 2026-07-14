extends CanvasLayer

@onready var animation = $AnimationPlayer   # Pastikan node ini ada sebagai anak langsung
@onready var rect = $ColorRect              # Pastikan node ini ada sebagai anak langsung

func _ready():

	if rect:
		rect.color.a = 0
	else:
		print("Peringatan: ColorRect tidak ditemukan!")

	if not animation:
		print("Peringatan: AnimationPlayer tidak ditemukan!")

func fade_out():

	show()
	if animation:
		animation.play("FadeOut")
		await animation.animation_finished
	else:
		print("Gagal memutar FadeOut: AnimationPlayer tidak ada.")

func fade_in():

	if animation:
		animation.play("FadeIn")
		await animation.animation_finished
	else:
		print("Gagal memutar FadeIn: AnimationPlayer tidak ada.")
	hide()
