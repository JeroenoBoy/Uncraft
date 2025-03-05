class_name CloseButton
extends Control

func _pressed() -> void:
	EventBus.instance.ui_cancel.emit()
