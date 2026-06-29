extends Node

# ==========================
# INVENTORY
# ==========================
var inventory: Array[String] = []

# ==========================
# UI REFERENCES
# ==========================
var dialog_label: Label
var dialog_panel: Control

var hint_label: Label
var hint_panel: Control

var notification_label: Label
var notification_panel: Control

# ==========================
# INVENTORY
# ==========================

func add_item(item):

	inventory.append(item)

	print(inventory)


func has_item(item_id: String) -> bool:

	return inventory.has(item_id)


func remove_item(item_id: String):

	if inventory.has(item_id):
		inventory.erase(item_id)


# ==========================
# DIALOG
# ==========================

func show_dialog(text:String):

	if dialog_panel == null:
		return

	dialog_panel.visible = true
	dialog_label.text = text


func hide_dialog():

	if dialog_panel == null:
		return

	dialog_panel.visible = false


# ==========================
# INTERACTION HINT
# ==========================

func show_interaction_hint(text:String):

	if hint_panel == null:
		return

	hint_panel.visible = true
	hint_label.text = text


func hide_interaction_hint():

	if hint_panel == null:
		return

	hint_panel.visible = false


# ==========================
# NOTIFICATION
# ==========================

func show_notification(text:String):

	if notification_panel == null:
		return

	notification_panel.visible = true
	notification_label.text = text

	await get_tree().create_timer(2.0).timeout

	notification_panel.visible = false
