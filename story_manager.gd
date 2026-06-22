extends Node

var current_story: int = 0

signal story_changed(story_id)

func advance_story():

	current_story += 1

	print("Story:", current_story)

	_apply_story_effects()

	story_changed.emit(current_story)

# =====================================
# STORY EVENTS
# =====================================
func _apply_story_effects():

	match current_story:

		# ------------------------
		# INTRO
		# ------------------------
		1:
			Hud.set_objective("Cari charger HP")

			PhoneNotif.push(
				"Pesan baru dari Beni"
			)

		# ------------------------
		# PERTAMA KALI RAKA MUNCUL
		# ------------------------
		2:
			Hud.set_raka_state(
				"Terlihat di ujung lorong"
			)

			GlitchFX.set_intensity(25)

			PhoneNotif.push(
				"Missed Call dari Beni"
			)

		# ------------------------
		# RAKA MENDEKAT
		# ------------------------
		3:
			Hud.set_raka_state(
				"Mulai mengawasimu"
			)

			GlitchFX.set_intensity(50)

			PhoneNotif.push(
				"Aku melihatmu..."
			)

		# ------------------------
		# HORROR EVENT
		# ------------------------
		4:
			Hud.set_raka_state(
				"Tepat di belakangmu"
			)

			GlitchFX.pulse(80, 0.5)

			PhoneNotif.push(
				"JANGAN MENENGOK"
			)

		# ------------------------
		# HAMPIR MATI
		# ------------------------
		5:
			Hud.set_raka_state(
				"Dia ada di dalam kepalamu"
			)

			GlitchFX.set_intensity(100)

			PhoneNotif.push(
				"AKU SUDAH MASUK"
			)
