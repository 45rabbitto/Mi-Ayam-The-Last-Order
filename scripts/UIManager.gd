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
var fade_rect: ColorRect

# ==========================================================
# TIMER
# ==========================================================

var dialog_timer: Timer
var notification_timer: Timer

# ==========================================================
# READY
# ==========================================================

func _ready() -> void:

	_create_timers()

	if InventoryManager:
		if !InventoryManager.inventory_changed.is_connected(update_inventory):
			InventoryManager.inventory_changed.connect(update_inventory)

	if ObjectiveManager:
		if !ObjectiveManager.objective_changed.is_connected(set_objective):
			ObjectiveManager.objective_changed.connect(set_objective)

# ==========================================================
# INITIALIZATION
# ==========================================================

func _create_timers() -> void:

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

# ==========================================================
# REGISTER HUD
# ==========================================================

func register_ui(
	p_dialog_panel: Control,
	p_dialog_label: Label,
	p_hint_panel: Control,
	p_hint_label: Label,
	p_notification_panel: Control,
	p_notification_label: Label,
	p_objective_label: Label,
	p_condition_label: Label,
	p_inventory_ui: Control,
	p_pause_menu: Control,
	p_crosshair: Control,
	p_fade_rect: ColorRect
) -> void:

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

	_initialize_ui()

	if InventoryManager:
		update_inventory(InventoryManager.get_items())

	if ObjectiveManager:
		set_objective(ObjectiveManager.get_objective())

# ==========================================================
# INITIAL UI STATE
# ==========================================================

func _initialize_ui() -> void:

	if dialog_panel:
		dialog_panel.hide()

	if hint_panel:
		hint_panel.hide()

	if notification_panel:
		notification_panel.hide()

	if pause_menu:
		pause_menu.hide()

	if fade_rect:
		fade_rect.modulate.a = 0.0

# ==========================================================
# DIALOG
# ==========================================================

func show_dialog(text: String) -> void:

	if dialog_panel == null:
		return

	dialog_panel.show()
	dialog_label.text = text

	dialog_timer.start()

func _hide_dialog() -> void:

	if dialog_panel:
		dialog_panel.hide()

	dialog_closed.emit()

# ==========================================================
# HINT
# ==========================================================

func show_hint(text: String) -> void:

	if hint_panel == null:
		return

	hint_panel.show()
	hint_label.text = text

func hide_hint() -> void:

	if hint_panel:
		hint_panel.hide()

# ==========================================================
# NOTIFICATION
# ==========================================================

func show_notification(text: String) -> void:

	if notification_panel == null:
		return

	notification_panel.show()
	notification_label.text = text

	notification_timer.start()

func _hide_notification() -> void:

	if notification_panel:
		notification_panel.hide()

# ==========================================================
# OBJECTIVE
# ==========================================================

func set_objective(text: String) -> void:

	if objective_label:
		objective_label.text = "Objective : %s" % text

# ==========================================================
# CONDITION
# ==========================================================

func set_condition(text: String) -> void:

	if condition_label:
		condition_label.text = "Kondisi Raka : %s" % text

# ==========================================================
# INVENTORY UI
# ==========================================================

func update_inventory(items: Array) -> void:

	if inventory_ui == null:
		return

	var slots = inventory_ui.get_children()

	# Bersihkan semua slot
	for slot in slots:

		var icon: TextureRect = slot.get_node_or_null("TextureRect")

		if icon:
			icon.texture = null
			icon.visible = false

	# Isi inventory
	for i in range(min(items.size(), slots.size())):

		var icon: TextureRect = slots[i].get_node_or_null("TextureRect")

		if icon:

			icon.texture = InventoryManager.get_item_icon(items[i])
			icon.visible = true
			
		slots[i].set_meta("item_id", items[i])
# ==========================================================
# CROSSHAIR
# ==========================================================

func show_crosshair() -> void:

	if crosshair:
		crosshair.show()

func hide_crosshair() -> void:

	if crosshair:
		crosshair.hide()

# ==========================================================
# PAUSE
# ==========================================================

func show_pause() -> void:

	if pause_menu:
		pause_menu.show()

func hide_pause() -> void:

	if pause_menu:
		pause_menu.hide()

func toggle_pause() -> void:

	get_tree().paused = !get_tree().paused

	if pause_menu:
		pause_menu.visible = get_tree().paused

# ==========================================================
# FADE
# ==========================================================

func fade_in(duration: float = 1.0) -> void:

	if fade_rect == null:
		return

	var tween := create_tween()

	tween.tween_property(
		fade_rect,
		"modulate:a",
		1.0,
		duration
	)

func fade_out(duration: float = 1.0) -> void:

	if fade_rect == null:
		return

	var tween := create_tween()

	tween.tween_property(
		fade_rect,
		"modulate:a",
		0.0,
		duration
	)
