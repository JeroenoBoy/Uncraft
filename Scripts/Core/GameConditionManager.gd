class_name GameConditionManager
extends Node

static var instance: GameConditionManager

var state: Dictionary

func _enter_tree() -> void:
	instance = self

func _exit_tree() -> void:
	instance = null

func get_value(condition: Resource) -> Variant:
	_check_exists(condition)
	return state[condition]

func set_value(condition: Resource, value: Variant):
	_check_exists(condition)
	state[condition] = value

func _check_exists(condition: Resource):
	if state.has(condition):
		return
	if !"default_value" in condition:
		push_error("Condition ", condition, " cannot be set as a GameCondition")
		return

	state[condition] = condition.default_value
