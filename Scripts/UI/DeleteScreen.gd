class_name DeleteScreen
extends UIScreen

signal delete_pressed()

func _show(_screen_data: Dictionary):
	visible = true

func _hide():
	visible = false

func _on_button_pressed():
	delete_pressed.emit()
