extends CanvasLayer

# =========================
# DIALOG
# =========================
@onready var dialog_panel = $DialogBox
@onready var dialog_label = $DialogBox/Label

# =========================
# INTERACTION HINT
# =========================
@onready var hint_panel = $InteractionHint
@onready var hint_label = $InteractionHint/Label

# =========================
# NOTIFICATION
# =========================
@onready var notification_panel = $NotificationPanel
@onready var notification_label = $NotificationPanel/Label

# =========================
# INVENTORY
# =========================
@onready var inventory_ui = get_node_or_null("InventoryUI")

# =========================
# CONDITION
# =========================
@onready var condition_label = get_node_or_null("ConditionLabel")

# =========================
# PAUSE MENU
# =========================
@onready var pause_menu = get_node_or_null("PauseMenu")

# =========================
# CROSSHAIR
# =========================
@onready var crosshair = get_node_or_null("Crosshair")


func _ready():

	# Hubungkan ke Global
	Global.dialog_panel = dialog_panel
	Global.dialog_label = dialog_label

	Global.hint_panel = hint_panel
	Global.hint_label = hint_label

	Global.notification_panel = notification_panel
	Global.notification_label = notification_label

	# Sembunyikan UI awal
	dialog_panel.visible = false
	hint_panel.visible = false
	notification_panel.visible = false

	if pause_menu:
		pause_menu.visible = false

	# Kondisi awal
	if condition_label:
		condition_label.text = "Kondisi Raka : 100%"

# ===================================
# CONDITION
# ===================================

func update_condition(text:String):

	if condition_label:
		condition_label.text = text


# ===================================
# NOTIFICATION
# ===================================

func notify(text:String):

	Global.show_notification(text)


# ===================================
# INVENTORY
# ===================================

func update_inventory(items:Array):

	print("Inventory:", items)

	# Nanti kita isi icon inventory di sini


# ===================================
# PAUSE MENU
# ===================================

func show_pause():

	if pause_menu:
		pause_menu.visible = true


func hide_pause():

	if pause_menu:
		pause_menu.visible = false


# ===================================
# CROSSHAIR
# ===================================

func show_crosshair():

	if crosshair:
		crosshair.visible = true


func hide_crosshair():

	if crosshair:
		crosshair.visible = false
