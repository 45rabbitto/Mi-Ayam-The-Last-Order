extends CanvasLayer


@onready var dialog_panel = $DialogBox
@onready var dialog_label = $DialogBox/Label

@onready var hint_panel = $InteractionHint
@onready var hint_label = $InteractionHint/Label

@onready var notification_panel = $NotificationPanel
@onready var notification_label = $NotificationPanel/Label


func _ready():

	Global.dialog_panel = dialog_panel
	Global.dialog_label = dialog_label

	Global.hint_panel = hint_panel
	Global.hint_label = hint_label

	Global.notification_panel = notification_panel
	Global.notification_label = notification_label

	dialog_panel.visible = false
	hint_panel.visible = false
	notification_panel.visible = false
