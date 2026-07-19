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


func _on_resume_pressed():

	AudioManager.play_ui("click")
	pause_menu.resume_game()


func _on_main_menu_pressed():

	AudioManager.play_ui("click")

	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	get_tree().change_scene_to_file(
		"res://scenes/mainmenu/mainmenu.tscn"
	)

func _on_quit_button_pressed():

	AudioManager.play_ui("click")

	get_tree().quit()


func _on_ButtonExplore_pressed():

	AudioManager.play_ui("click")

	ObjectiveManager.complete_current()

	$level2ui/ButtonExplore.hide()

func _on_ButtonRearrange_pressed():
	
	print("=== BUTTON REARRANGE DIPENCET ===")
	
	if AudioManager:
		AudioManager.play_ui("click")
	
	if ObjectiveManager:
		ObjectiveManager.complete_current()
	
	var err = get_tree().change_scene_to_file("res://scenes/LoadingUI.tscn")
	if err != OK:
		print("GAGAL PINDAH SCENE! Error code: ", err)
	else:
		print("Berhasil request pindah ke LoadingUI")


func _on_button_next_level_3_pressed() -> void:
	get_tree().change_scene_to_file(
		"res://scenes/storych3.tscn"
	)


func _on_button_next_chapter_5_pressed() -> void:

	AudioManager.play_ui("click")

	get_tree().change_scene_to_file(
		"res://scenes/storych5.tscn"
	)


func _on_button_next_level_4_pressed() -> void:

	Transition.fade_out()

	await get_tree().create_timer(1.0).timeout

	get_tree().change_scene_to_file(
		"res://scenes/level/level_5_ending.tscn"
	)
