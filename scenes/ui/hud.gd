extends CanvasLayer

# ==========================================================
# UI REFERENCES
# ==========================================================

@onready var dialog_panel = $DialogBox
@onready var dialog_label = $DialogBox/Label

@onready var hint_panel = $InteractionHint
@onready var hint_label = $InteractionHint/Label

@onready var notification_panel = $NotificationPanel
@onready var notification_label = $NotificationPanel/Label

@onready var objective_label = $ObjectivePanel/VBoxContainer/Label
@onready var condition_label = $ConditionLabel

@onready var inventory_ui = $InventoryUI
@onready var pause_menu = $PauseMenu
@onready var crosshair = $CrossHair

# Fade boleh tidak ada
@onready var fade_rect = get_node_or_null("Fade")


func _ready():
	if $DialogBox/AnimationPlayer:
		$DialogBox/AnimationPlayer.stop()

	if $InteractionHint/AnimationPlayer:
		$InteractionHint/AnimationPlayer.stop()

	if $NotificationPanel/AnimationPlayer:
		$NotificationPanel/AnimationPlayer.stop()
		
	UiManager.register_ui(
		dialog_panel,
		dialog_label,
		hint_panel,
		hint_label,
		notification_panel,
		notification_label,
		objective_label,
		condition_label,
		inventory_ui,
		pause_menu,
		crosshair,
		fade_rect
	)
	print("DialogBox dari UiManager =", dialog_panel)

	# Hide default
	dialog_panel.hide()
	hint_panel.hide()
	notification_panel.hide()
	pause_menu.hide()

	if fade_rect:
		fade_rect.modulate.a = 0.0

	# Default text
	UiManager.set_objective("")
	UiManager.set_condition("100%")

	# Inventory
	if InventoryManager:

		if !InventoryManager.inventory_changed.is_connected(_inventory_changed):
			InventoryManager.inventory_changed.connect(_inventory_changed)

		_inventory_changed(InventoryManager.get_items())


# ==========================================================
# INVENTORY
# ==========================================================

func _inventory_changed(items: Array):

	update_inventory(items)


func update_inventory(items:Array):

	if inventory_ui == null:
		return

	# Inventory berupa Label
	if inventory_ui is Label:

		if items.is_empty():
			inventory_ui.text = ""
		else:

			inventory_ui.text = ""

			for item in items:
				inventory_ui.text += "• " + item + "\n"

	# Inventory berupa VBoxContainer
	elif inventory_ui is VBoxContainer:

		for child in inventory_ui.get_children():
			child.queue_free()

		for item in items:

			var label := Label.new()
			label.text = item

			inventory_ui.add_child(label)


# ==========================================================
# FADE
# ==========================================================

func fade_in():

	if fade_rect == null:
		return

	var tween := create_tween()

	tween.tween_property(
		fade_rect,
		"modulate:a",
		1.0,
		1.0
	)


func fade_out():

	if fade_rect == null:
		return

	var tween := create_tween()

	tween.tween_property(
		fade_rect,
		"modulate:a",
		0.0,
		1.0
	)
