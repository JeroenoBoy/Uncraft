class_name UIScreen
extends Control

var is_showing = false
var has_shown_once = false

func show_screen(screen_data: Dictionary = {}):
	if is_showing:
		push_warning("Tried showing an active ui screen")
		return

	if !has_shown_once:
		_first_show()
		has_shown_once = true

	is_showing = true
	_show(screen_data)

func hide_screen():
	if !is_showing:
		push_warning("Tried hiding a hidden ui screen")
		return

	is_showing = false
	_hide()

func _ready() -> void:
	visible = false

func _first_show():
	pass

func _show(_screen_data: Dictionary):
	pass

func _hide():
	pass
