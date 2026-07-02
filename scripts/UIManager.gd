extends Node

signal dialog_closed

# ==========================================================
# UI REFERENCES
# ==========================================================

var dialog_panel: Control
var dialog_label: Label

var hint_panel: Control
var hint_label: Label

var notification_panel: Control
var notification_label: Label

var objective_label: Label
var condition_label: Label

var inventory_ui: Control

var pause_menu: Control
var crosshair: Control
var fade_rect: Control

# ==========================================================
# TIMER
# ==========================================================

var dialog_timer: Timer
var notification_timer: Timer

# ==========================================================
# ITEM ICON
# ==========================================================
var preview_scene = preload("res://scenes/ItemPreview.tscn")
var item_models = {

	"charger":"res://assets/3d/phone_charger_low_poly.glb",

	"phone":"res://assets/3d/cell_phone.glb",

}

# ==========================================================
# READY
# ==========================================================

func _ready():

	dialog_timer = Timer.new()
	dialog_timer.one_shot = true
	dialog_timer.wait_time = 3.0
	dialog_timer.timeout.connect(_hide_dialog)
	add_child(dialog_timer)

	notification_timer = Timer.new()
	notification_timer.one_shot = true
	notification_timer.wait_time = 2.0
	notification_timer.timeout.connect(_hide_notification)
	add_child(notification_timer)

	if InventoryManager:

		if !InventoryManager.inventory_changed.is_connected(_on_inventory_changed):
			InventoryManager.inventory_changed.connect(_on_inventory_changed)

# ==========================================================
# REGISTER UI
# ==========================================================

func register_ui(
	p_dialog_panel,
	p_dialog_label,
	p_hint_panel,
	p_hint_label,
	p_notification_panel,
	p_notification_label,
	p_objective_label,
	p_condition_label,
	p_inventory_ui,
	p_pause_menu,
	p_crosshair,
	p_fade_rect
):

	dialog_panel = p_dialog_panel
	dialog_label = p_dialog_label

	hint_panel = p_hint_panel
	hint_label = p_hint_label

	notification_panel = p_notification_panel
	notification_label = p_notification_label

	objective_label = p_objective_label
	condition_label = p_condition_label

	inventory_ui = p_inventory_ui

	pause_menu = p_pause_menu
	crosshair = p_crosshair
	fade_rect = p_fade_rect

	if dialog_panel:
		dialog_panel.hide()

	if hint_panel:
		hint_panel.hide()

	if notification_panel:
		notification_panel.hide()

	if pause_menu:
		pause_menu.hide()

	if fade_rect:
		fade_rect.modulate.a = 0

	_on_inventory_changed(InventoryManager.get_items())

# ==========================================================
# INVENTORY SIGNAL
# ==========================================================

func _on_inventory_changed(items: Array):

	update_inventory(items)

# ==========================================================
# DIALOG
# ==========================================================

func show_dialog(text:String):

	print("SHOW DIALOG")
	print(dialog_panel)
	print(dialog_label)

	if dialog_panel == null:
		print("dialog_panel NULL")
		return

	dialog_panel.visible = true
	dialog_panel.modulate.a = 1.0

	dialog_label.visible = true
	dialog_label.text = text

	print("VISIBLE =", dialog_panel.visible)
	print("TEXT =", dialog_label.text)

func _hide_dialog():

	if dialog_panel:
		dialog_panel.hide()

	dialog_closed.emit()

# ==========================================================
# HINT
# ==========================================================

func show_hint(text:String):

	if hint_panel == null:
		return

	hint_panel.show()
	hint_label.text = text

func hide_hint():

	if hint_panel:
		hint_panel.hide()

# ==========================================================
# NOTIFICATION
# ==========================================================

func show_notification(text:String):

	if notification_panel == null:
		return

	notification_panel.show()

	if notification_label:
		notification_label.text = text

	notification_timer.start()

func _hide_notification():

	if notification_panel:
		notification_panel.hide()

# ==========================================================
# OBJECTIVE
# ==========================================================

func set_objective(text:String):

	print("SET OBJECTIVE DIPANGGIL:", text)
	print("OBJECTIVE LABEL =", objective_label)

	if objective_label:
		objective_label.text = "Objective : " + text

# ==========================================================
# CONDITION
# ==========================================================

func set_condition(text:String):

	if condition_label:
		condition_label.text = "Kondisi Raka : " + text

# ==========================================================
# INVENTORY
# ==========================================================
func update_inventory(items: Array):

	if inventory_ui == null:
		return

	var slots = inventory_ui.get_children()

	# Bersihkan semua slot
	for slot in slots:
		var icon = slot.get_node_or_null("TextureRect")
		if icon:
			icon.texture = null
			icon.visible = false

	# Isi slot sesuai item
	for i in range(min(items.size(), slots.size())):

		var item_name = items[i].to_lower()

		if !item_models.has(item_name):
			continue

		var preview = preview_scene.instantiate()
		add_child(preview)

		preview.load_item(item_models[item_name])

		await get_tree().process_frame
		await get_tree().process_frame

		var icon = slots[i].get_node_or_null("TextureRect")

		if icon:
			icon.texture = preview.get_preview()
			icon.visible = true

		preview.queue_free()

# ==========================================================
# CROSSHAIR
# ==========================================================

func show_crosshair():

	if crosshair:
		crosshair.show()

func hide_crosshair():

	if crosshair:
		crosshair.hide()

# ==========================================================
# PAUSE
# ==========================================================

func show_pause():

	if pause_menu:
		pause_menu.show()

func hide_pause():

	if pause_menu:
		pause_menu.hide()

func toggle_pause():

	if pause_menu:
		pause_menu.visible = !pause_menu.visible

# ==========================================================
# FADE
# ==========================================================

func fade_in():

	if fade_rect == null:
		return

	var tween = create_tween()
	tween.tween_property(fade_rect,"modulate:a",1.0,1.0)

func fade_out():

	if fade_rect == null:
		return

	var tween = create_tween()
	tween.tween_property(fade_rect,"modulate:a",0.0,1.0)
