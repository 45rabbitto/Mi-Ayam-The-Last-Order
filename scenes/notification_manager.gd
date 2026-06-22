extends Node

var queue: Array = []
var is_showing := false

var notif_scene = preload("res://scenes/notification/phone_notification.tscn")
var notif_instance = null

func push(text: String, duration := 3.0):

	queue.append({
		"text": text,
		"duration": duration
	})

	if not is_showing:
		_show_next()

func _show_next():

	if queue.is_empty():
		is_showing = false
		return

	is_showing = true

	var data = queue.pop_front()

	if notif_instance == null:
		notif_instance = notif_scene.instantiate()
		get_tree().root.call_deferred("add_child", notif_instance)
		await get_tree().process_frame

	# ❗ DEBUG WAJIB
	print("INSTANCE:", notif_instance)
	print("SCRIPT:", notif_instance.get_script())

	# FIX UTAMA: jangan pakai has_method dulu
	await notif_instance.show_notification(
		data["text"],
		data["duration"]
	)

	_show_next()
