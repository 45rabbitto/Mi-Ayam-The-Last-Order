extends Node

signal dialog_closed

var dialog_panel: Panel
var dialog_label: Label
var hint_panel: Panel
var hint_label: Label
var notification_panel: Panel
var notification_label: Label
var pause_menu: Control

var dialog_timer: Timer
var notification_timer: Timer

func _ready():
	# Cari UI di scene
	await get_tree().process_frame
	setup_ui()

func setup_ui():
	var canvas = get_tree().current_scene.get_node("CanvasLayer")
	if canvas:
		dialog_panel = canvas.get_node_or_null("DialogBox")
		dialog_label = canvas.get_node_or_null("DialogBox/Label")
		hint_panel = canvas.get_node_or_null("InteractionHint")
		hint_label = canvas.get_node_or_null("InteractionHint/Label")
		notification_panel = canvas.get_node_or_null("NotificationPanel")
		notification_label = canvas.get_node_or_null("NotificationPanel/Label")
		pause_menu = canvas.get_node_or_null("PauseMenu")
		
		# Sembunyikan semua
		if dialog_panel: dialog_panel.hide()
		if hint_panel: hint_panel.hide()
		if notification_panel: notification_panel.hide()
		if pause_menu: pause_menu.hide()
		
		# Buat timer
		dialog_timer = Timer.new()
		dialog_timer.wait_time = 3.0
		dialog_timer.one_shot = true
		dialog_timer.timeout.connect(_hide_dialog)
		add_child(dialog_timer)
		
		notification_timer = Timer.new()
		notification_timer.wait_time = 2.0
		notification_timer.one_shot = true
		notification_timer.timeout.connect(_hide_notification)
		add_child(notification_timer)

func show_dialog(text: String, voice_key: String = ""):
	if dialog_panel:
		dialog_panel.show()
		if dialog_label:
			dialog_label.text = text
		dialog_timer.start()
		
		# Mainkan suara jika ada
		if voice_key != "":
			AudioManager.play_voice(AudioManager.voice_clips_ch1.get(voice_key))

func _hide_dialog():
	if dialog_panel:
		dialog_panel.hide()
	emit_signal("dialog_closed")

func show_hint(text: String):
	if hint_panel:
		hint_panel.show()
		if hint_label:
			hint_label.text = text

func hide_hint():
	if hint_panel:
		hint_panel.hide()

func show_notification(text: String):
	if notification_panel:
		notification_panel.show()
		if notification_label:
			notification_label.text = text
		notification_timer.start()

func _hide_notification():
	if notification_panel:
		notification_panel.hide()

func toggle_pause_menu():
	if pause_menu:
		pause_menu.visible = !pause_menu.visible
