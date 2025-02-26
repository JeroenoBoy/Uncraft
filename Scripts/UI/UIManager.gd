class_name UIManager
extends Control

static var instance: UIManager

var is_mouse_over_ui = false

func _init() -> void:
	instance = self

func get_screen(path: String) -> UIScreen:
	var node = find_child(path)
	if node is not UIScreen:
		return null

	return node as UIScreen

func show_screen(path: String, screen_data: Dictionary):
	get_screen(path).show_screen(screen_data)

func hide_screen(path: String):
	get_screen(path).hide_screen()

func _on_mouse_entered():
	is_mouse_over_ui = true

func _on_mouse_exited():
	is_mouse_over_ui = true
