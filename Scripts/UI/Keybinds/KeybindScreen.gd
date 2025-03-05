class_name KeybindScreen
extends UIScreen

@export var widget: PackedScene
@export var container: Control

func _show(_screen_data: Dictionary):
	visible = true

	var keybinds := _screen_data["keybinds"] as Array[KeybindWidget.Data]

	for child in container.get_children():
		child.queue_free()

	for keybind in keybinds:
		var instance = widget.instantiate() as KeybindWidget
		container.add_child(instance)
		instance.set_data(keybind)

func _hide():
	visible = false
