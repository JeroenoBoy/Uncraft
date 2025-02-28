class_name EventBus
extends Node

static var instance: EventBus

func _init() -> void:
	instance = self

signal unlock_condition_triggered(condition: GameCondition)
