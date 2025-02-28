class_name GameConditionManager
extends Node

static var instance: GameConditionManager

var state: Dictionary

func _enter_tree() -> void:
	instance = self

func _exit_tree() -> void:
	instance = null

func get_value(condition: GameCondition) -> Variant:
	_check_exists(condition)
	return state[condition]

func set_value(condition: GameCondition, value: Variant):
	_check_exists(condition)
	state[condition] = value

func _check_exists(condition: GameCondition):
	if state.has(condition):
		return

	state[condition] = condition.default_value
