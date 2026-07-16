extends Node


var current_level := 1

# ==========================
# INVENTORY
# ==========================
var inventory: Array[String] = []

# ==========================
# UI REFERENCES (DI-ASSIGN DARI SCENE)
# ==========================
var dialog_label: Label
var dialog_panel: Control

var hint_label: Label
var hint_panel: Control

var notification_label: Label
var notification_panel: Control


# ==========================
# INIT UI BINDING
# ==========================
func bind_ui(dialog_p: Control, dialog_l: Label,
			 hint_p: Control, hint_l: Label,
			 notif_p: Control, notif_l: Label):

	dialog_panel = dialog_p
	dialog_label = dialog_l

	hint_panel = hint_p
	hint_label = hint_l

	notification_panel = notif_p
	notification_label = notif_l


# ==========================
# INVENTORY SYSTEM
# ==========================
func add_item(item: String):
	inventory.append(item)
	print("ADD ITEM ->", item)
	print(inventory)


func has_item(item_id: String) -> bool:
	return inventory.has(item_id)


func remove_item(item_id: String):
	if inventory.has(item_id):
		inventory.erase(item_id)


# ==========================
# DIALOG SYSTEM
# ==========================
func show_dialog(text: String):
	if dialog_panel == null or dialog_label == null:
		return

	dialog_panel.visible = true
	dialog_label.text = text


func hide_dialog():
	if dialog_panel == null:
		return

	dialog_panel.visible = false


# ==========================
# INTERACTION HINT SYSTEM
# ==========================
func show_interaction_hint(text: String):
	if hint_panel == null or hint_label == null:
		return

	hint_panel.visible = true
	hint_label.text = text


func hide_interaction_hint():
	if hint_panel == null:
		return

	hint_panel.visible = false


# ==========================
# NOTIFICATION SYSTEM
# ==========================
func show_notification(text: String):
	if notification_panel == null or notification_label == null:
		return

	notification_panel.visible = true
	notification_label.text = text

	await get_tree().create_timer(2.0).timeout
	notification_panel.visible = false
