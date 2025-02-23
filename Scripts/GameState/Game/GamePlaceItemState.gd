class_name GamePlaceItemState
extends BaseMoveBuildingState

var item: PlaceableItem
var cancelAction: CancelableAction

func _init():
	_item_selector = true;

func _on_activate(state_data: Dictionary):
	super._on_activate({})

	if !state_data.has("item"):
		push_error("Item was not found in 'state_data'")
		state_machine.change_state("Default")
		return

	item = state_data["item"]
	reset_position_to_mouse()
	_create_item(item)

func _on_deactivate():
	super._on_deactivate()

	object = null
	if cancelAction != null:
		cancelAction.cancel()
		cancelAction = null

func _on_place():
	object.place()
	_create_item(item)

func _on_cancel():
	state_machine.change_state("Default")

func _create_item(from: PlaceableItem):
	var node = from.node.instantiate()
	if node is not GridNode:
		push_error("Could not place item '" + from.name + "'")
		node.queue_free()
		state_machine.change_state("Default")
		return

	var grid_node = node as GridNode
	grid_node.place_on_spawn = false
	Grid.instance.add_child(grid_node)
	cancelAction = DestroyObjectCancelAction.new(grid_node)
	set_object(grid_node)

