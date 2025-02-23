class_name GamePlaceItemState
extends BaseGameState

var item: PlaceableItem
var object: GridNode
var cancelAction: CancelableAction
var multi_place = true

var current_pos: Vector2i
var can_place = false
var current_rotation = 0

func _init():
	_item_selector = true;

func _on_activate(state_data: Dictionary):
	super._on_activate({})

	if state_data["item"] != null:
		current_rotation = 0
		item = state_data["item"]
		multi_place = true
		_create_item(item)

func _on_deactivate():
	super._on_deactivate()

	object = null
	if cancelAction != null:
		cancelAction.cancel()
		cancelAction = null

func _update(delta: float):
	super._update(delta)

	var mouse_pos = get_viewport().get_camera_2d().get_global_mouse_position()
	var grid_pos = Grid.world_to_grid(mouse_pos + Vector2(Grid.CELL_SIZE / 2.0, Grid.CELL_SIZE / 2.0))
	if grid_pos != current_pos:
		current_pos = grid_pos
		object.position = Grid.grid_to_world(current_pos)
		_check_valid_position()

	if can_place && Input.is_action_just_pressed("build_place"):
		object.place()
		_create_item(item)

	if object.rotatable && Input.is_action_just_pressed("build_rotate"):
		object.global_rotation_degrees += 90
		current_rotation = object.global_rotation_degrees

	if Input.is_action_just_pressed("build_cancel"):
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
	object = grid_node
	object.global_rotation_degrees = current_rotation
	object.position = Grid.grid_to_world(current_pos)
	_check_valid_position()

func _check_valid_position():
	can_place = Grid.instance.is_spot_occupied(object)
