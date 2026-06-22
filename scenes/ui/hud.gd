extends CanvasLayer

@onready var objective_label: Label = $ObjectiveLabel
@onready var interaction_label: Label = $InteractionLabel
@onready var notification_panel = $NotificationPanel
@onready var notification_text: Label = $NotificationPanel/NotificationText
@onready var condition_label: Label = $ConditionLabel

@onready var crosshair = $Crosshair


func _ready() -> void:
	add_to_group("hud")

	if objective_label:
		objective_label.text = "TEST OBJECTIVE"

	show_notification("TEST NOTIFICATION")
	hide_interaction()


# =====================================
# OBJECTIVE
# =====================================
func set_objective(text: String) -> void:
	if objective_label:
		objective_label.text = text


# =====================================
# INTERACTION
# =====================================
func show_interaction(text: String = "Press E to interact") -> void:
	if interaction_label:
		interaction_label.text = text
		interaction_label.visible = true


func hide_interaction() -> void:
	if interaction_label:
		interaction_label.visible = false


# =====================================
# NOTIFICATION
# =====================================
func show_notification(text: String) -> void:
	if notification_text:
		notification_text.text = text

	if notification_panel:
		notification_panel.visible = true

	await get_tree().create_timer(3.0).timeout

	if notification_panel:
		notification_panel.visible = false


# =====================================
# CROSSHAIR
# =====================================
func set_crosshair(state: bool) -> void:
	if crosshair:
		crosshair.visible = state


# =====================================
# CONDITION
# =====================================
func set_raka_state(text: String) -> void:
	if condition_label:
		condition_label.text = text
