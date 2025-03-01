class_name CheatScreen
extends UIScreen

signal button_pressed(id: Variant)

@export var button_scene: PackedScene
@export var button_container: Control

func _show(screen_data: Dictionary):
	for child in button_container.get_children():
		child.queue_free()
	visible = true

	for btn in screen_data["buttons"]:
		var instance = button_scene.instantiate() as Button
		button_container.add_child(instance)
		instance.text = btn.name
		instance.pressed.connect(func(): button_pressed.emit(btn.data))

func _hide():
	for child in button_container.get_children():
		child.queue_free()
	visible = false

class Btn:
	var name: String
	var data: Variant

	func _init(name: String, data: Variant) -> void:
		self.name = name
		self.data = data
