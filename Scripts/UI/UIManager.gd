class_name UIManager
extends Node

static var instance: UIManager

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
