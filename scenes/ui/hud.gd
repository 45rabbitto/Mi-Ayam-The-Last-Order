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
@onready var fade_rect = get_node_or_null("Fade")

# ==========================================================
# READY
# ==========================================================

func _ready():

	_stop_animations()

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

# ==========================================================
# PRIVATE
# ==========================================================

func _stop_animations():

	_stop_animation(dialog_panel)
	_stop_animation(hint_panel)
	_stop_animation(notification_panel)


func _stop_animation(node: Node):

	if node == null:
		return

	var animation = node.get_node_or_null("AnimationPlayer")

	if animation:
		animation.stop()
