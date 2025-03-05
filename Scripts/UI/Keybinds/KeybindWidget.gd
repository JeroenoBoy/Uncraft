class_name KeybindWidget
extends Control

@export var name_label: Label
@export var key_label: Label

func set_data(data: Data):
	name_label.text = data.name
	key_label.text = data.key

class Data:
	var name: String
	var key: String

	func _init(name: String, key: String) -> void:
		self.name = name
		self.key = key
