class_name State
extends Node

var state_machine: StateMachine
var is_active_state = false

func _ready() -> void:
	var parent = get_parent()
	if self is StateMachine && parent is not StateMachine:
		return

	if parent is not StateMachine:
		push_error("Parent of state was not a statemachine")
		return

	state_machine = parent as StateMachine

func _update(_delta: float):
	pass

func _on_activate():
	pass

func _on_deactivate():
	pass
