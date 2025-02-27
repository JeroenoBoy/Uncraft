class_name DeleteScreen
extends UIScreen

signal delete_pressed()

var is_mouse_over_screen = false

func _show(_screen_data: Dictionary):
	visible = true

func _hide():
	visible = false

func _on_button_pressed():
	delete_pressed.emit()


func _on_button_mouse_entered() -> void:
	is_mouse_over_screen = true


func _on_button_mouse_exited() -> void:
	is_mouse_over_screen = false
