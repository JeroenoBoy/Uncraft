class_name GameMoveBuildingState
extends BaseMoveBuildingState

var cancelAction: CancelableAction

func _on_first_activate():
	super._on_first_activate()

func _on_activate(state_data: Dictionary):
	super._on_activate(state_data)

	if !state_data.has("building"):
		push_error("Building was not found in 'state_data'")
		state_machine.change_state("Default")
		return

	var building = state_data["building"] as GridNode
	reset_position_to_building(building)
	cancelAction = MoveBuildingBackCancelAction.new(building, current_pos, current_rotation)
	building.pickup()
	set_object(building)

func _on_deactivate():
	super._on_deactivate()

	object = null
	if cancelAction != null:
		cancelAction.cancel()
		cancelAction = null

func _on_place():
	object.place()
	cancelAction = null
	state_machine.change_state("Default")

func _on_cancel():
	state_machine.change_state("Default")

func _on_delete():
	object.queue_free()
	cancelAction = null
	state_machine.change_state("Default")
