class_name GameStateMachine
extends StateMachine

func _on_activate(state_data: Dictionary):
	change_state("Default")
