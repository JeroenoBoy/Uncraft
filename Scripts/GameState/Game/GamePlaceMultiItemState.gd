class_name GamePlaceMultiItemState
extends BaseGameState

var item: PlaceableItem
var selectable_item: SelectableItem
var start_pos = Vector2i.ZERO
var prev_mouse_pos = Vector2i.ZERO

var active_tiles: Array[GridNode] = []
var inactive_tiles: Array[GridNode] = []

func _init():
	item_selector = true
	can_move_camera = true

func _on_activate(state_data: Dictionary):
	super._on_activate(state_data)

	if state_data.has("selectable_item"):
		selectable_item = state_data["selectable_item"]

	item = state_data["item"]
	start_pos = state_data["start_pos"]

	_create_path()

func _on_deactivate():
	super._on_deactivate()

	for tile in active_tiles:
		tile.queue_free()
	for tile in inactive_tiles:
		tile.queue_free()

	active_tiles.clear()
	inactive_tiles.clear()

	selectable_item = null

func _on_input(event: InputEvent):
	super._on_input(event)

	if event.is_action_released("build_place"):
		_place_all()
	elif event.is_action_pressed("build_cancel"):
		_on_cancel()
	elif event.is_action_pressed("build_delete"):
		_on_delete()

func _update(delta: float):
	super._update(delta)

	if Grid.grid_mouse_pos() != prev_mouse_pos:
		_create_path()

func _on_cancel():
	state_machine.change_state("Default")

func _on_delete():
	state_machine.change_state("Default")

func _place_all():
	for active in active_tiles:
		active.place()
	active_tiles.clear()
	state_machine.change_state("PlaceItem", {
		"item": item,
		"selectable_item": selectable_item
	})

func _create_path():
	var target = Grid.grid_mouse_pos()
	prev_mouse_pos = target
	target = Grid.instance.get_closest_free_point(target)
	var path = Grid.instance.astar.get_point_path(start_pos, target, true)

	_inactivate_all()

	var dir = Grid.grid_precise_mouse_pos() - Vector2(target)
	if abs(dir.x) > abs(dir.y):
		dir.y = 0
	else:
		dir.x = 0

	if dir.length_squared() <= 0.5:
		dir = -dir

	var parent_pos = target + Vector2i(dir.normalized())
	for i in range(path.size()-1, -1, -1):
		var pos = Vector2i(path[i])
		dir = parent_pos - pos
		var rot = 0
		if dir.x > 0:
			rot = PI * 0.5
		elif dir.y > 0:
			rot = PI
		elif dir.x < 0:
			rot = PI * 1.5

		var node = _get_tile()
		node.position = Grid.grid_to_world(pos)
		node.global_rotation = rot
		parent_pos = pos

func _get_tile() -> GridNode:
	if !inactive_tiles.is_empty():
		var tile = inactive_tiles.pop_back()
		tile.visible = true
		active_tiles.append(tile)
		return tile
	else:
		var node = _create_item(item)
		active_tiles.append(node)
		return node

func _inactivate_all():
	while !active_tiles.is_empty():
		var tile = active_tiles.pop_back()
		tile.visible = false
		inactive_tiles.append(tile)

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
	return grid_node
