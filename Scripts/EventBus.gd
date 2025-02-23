class_name EventBus
extends Node

static var instance: EventBus

func _init() -> void:
	instance = self

signal on_building_clicked(node: GridNode)
