class_name GamePlaceItemState
extends BaseMoveBuildingState

var item: PlaceableItem
var selectable_item: SelectableItem
var cancel_action: CancelableAction

var is_holding_place: bool
var place_start_pos: Vector2i
var previous_node: GridNode

func _init():
	super._init()
	item_selector = true;

func _on_activate(state_data: Dictionary):
	super._on_activate(state_data)

	if !state_data.has("item"):
		push_error("Item was not found in 'state_data'")
		state_machine.change_state("Default")
		return

	if state_data.has("selectable_item"):
		selectable_item = state_data["selectable_item"]

	is_holding_place = false

	item = state_data["item"]
	reset_position_to_mouse()
	_create_item(item)

func _on_deactivate():
	super._on_deactivate()

	if cancel_action != null:
		cancel_action.cancel()
		cancel_action = null

	_update_selectable()
	selectable_item = null
	object = null

func _on_input(event: InputEvent):
	if event.is_action_pressed("build_place"):
		is_holding_place = true
		place_start_pos = Grid.grid_mouse_pos()
	
	if event.is_action_released("build_place"):
		is_holding_place = false

	if super._on_input(event):
		return true

	return false

func _update(delta: float):
	super._update(delta)

	if !is_holding_place:
		return
	if !item.multi_place:
		return
	var mouse_pos = Grid.grid_mouse_pos()
	if mouse_pos == place_start_pos:
		return
	if previous_node != null:
		previous_node.pickup()
		previous_node.queue_free()

	state_machine.change_state("PlaceMulti", {
		"start_pos": place_start_pos,
		"item": item,
		"selectable_item": selectable_item
	})

func _on_place():
	object.place()
	_create_item(item)

func _on_cancel():
	state_machine.change_state("Default")

func _on_delete():
	object.queue_free()
	cancel_action = null
	state_machine.change_state("Default")

func _create_item(from: PlaceableItem):
	if !from.can_place():
		cancel_action = null
		state_machine.change_state("Default")
		return

	var node = from.node.instantiate()
	if node is not GridNode:
		push_error("Could not place item '" + from.name + "'")
		node.queue_free()
		state_machine.change_state("Default")
		return

	var grid_node = node as GridNode
	grid_node.place_on_spawn = false
	Grid.instance.add_child(grid_node)
	cancel_action = DestroyObjectCancelAction.new(grid_node)
	previous_node = object
	set_object(grid_node)

	_update_selectable()

func _update_selectable():
	if selectable_item == null:
		return
	var placable_item = selectable_item.data.id as PlaceableItem
	if placable_item.place_limit == null || placable_item.placed_store == null:
		return
	var max_count = placable_item.place_limit.get_value()
	var current = placable_item.placed_store.get_objects().size()
	selectable_item.data.max_count = max_count
	selectable_item.set_current_count(max_count - current)
