extends Node

func enable_blur():
	BlurOverlay.enable()

func disable_blur():
	BlurOverlay.disable()

func blur(amount := 50):
	BlurOverlay.enable()
	BlurOverlay.fade_to(amount)

func pulse_blur():
	BlurOverlay	.pulse()
