extends Node

signal story_changed(story_id)

var current_story: int = 0

func advance_story() -> void:
	current_story += 1

	print("Story:", current_story)

	_apply_story_effects()

	story_changed.emit(current_story)


# =====================================================
# STORY EVENTS
# =====================================================
func _apply_story_effects() -> void:

	match current_story:

		# =====================================================
		# STORY 1
		# =====================================================
		1:
			if Engine.has_singleton("PhoneNotif"):
				PhoneNotif.push("Pesan baru dari Beni")

		# =====================================================
		# STORY 2
		# =====================================================
		2:
			if Engine.has_singleton("PhoneNotif"):
				PhoneNotif.push("Missed Call dari Beni")

		# =====================================================
		# STORY 3
		# =====================================================
		3:
			if Engine.has_singleton("PhoneNotif"):
				PhoneNotif.push("Aku melihatmu...")

		# =====================================================
		# STORY 4
		# =====================================================
		4:
			if Engine.has_singleton("PhoneNotif"):
				PhoneNotif.push("JANGAN MENENGOK")

		# =====================================================
		# STORY 5
		# =====================================================
		5:
			if Engine.has_singleton("PhoneNotif"):
				PhoneNotif.push("AKU SUDAH MASUK")
