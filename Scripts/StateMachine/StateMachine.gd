class_name StateMachine
extends State

var current_state: State


func change_state(state_path: String, state_data: Dictionary = {}):
	var child = find_child(state_path)
	if child is not State:
		push_error("Tried to go to state which is not a state, path="+state_path)
		return

	var state = child as State
	state.state_machine = self

	if state.state_machine != self:
		return

	_deactivate_state(current_state)
	current_state = state
	_activate_state(state, state_data)

func deactivate():
	_deactivate_state(current_state)
	current_state = null

func _process(delta: float) -> void:
	if current_state != null:
		current_state._update(delta)

func _activate_state(state: State, state_data: Dictionary):
	state.is_active_state = true
	state._on_activate(state_data)
	
func _deactivate_state(state: State):
	if state == null:
		return
	state._on_deactivate()
	state.is_active_state = false;
