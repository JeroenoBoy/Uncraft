class_name EventBus
extends Node

signal ui_cancel()

static var instance: EventBus

func _init() -> void:
	instance = self
