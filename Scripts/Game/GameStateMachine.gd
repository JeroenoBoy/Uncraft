class_name GameStateMachine
extends StateMachine

func _ready() -> void:
	super._ready()
	change_state("init")
