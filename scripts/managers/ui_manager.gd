extends Node

var hud = null

func register_hud(hud_node):
	hud = hud_node

func notify(text):
	if hud:
		hud.notify(text)

func show_interaction(text):
	if hud:
		hud.show_interaction(text)

func hide_interaction():
	if hud:
		hud.hide_interaction()

func set_objective(text):
	if hud:
		hud.set_objective(text)

func update_condition(text):
	if hud:
		hud.update_condition(text)
