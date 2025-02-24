class_name Conveyor
extends GridNode

@export var conveyor_speed = 1.0 / (32.0 / 10.0 / 4.0)
@onready var inventory: Inventory = $Inventory

var next_node: GridNode
var previous_nodes: Array[GridNode] = []
var _last_grabbed_child = 0
var _locked: bool = false

func _ready() -> void:
	tile_update.connect(_on_tile_update)
	function_update.connect(_on_function_update)
	picked_up.connect(_on_picked_up)

func conveyor_accepts(item_data: ItemData) -> bool:
	return !_locked && inventory.can_hold(item_data)

func conveyor_input(item: Item) -> bool:
	if _locked:
		return false
	if !inventory.can_hold(item.item_data):
		return false

	item.global_position = global_position
	inventory.add_item_skip_checks(item)
	_process_item(item)
	return true

func _on_tile_update():
	_clear_connections()

	var pos = grid_position()
	var rot = grid_rotation()

	var nodes_infront = Grid.instance.get_grid_nodes(pos + rot)
	for grid_node in nodes_infront:
		var other_rot = grid_node.grid_rotation()
		if Grid.fast_rotate(other_rot, 180) == rot:
			continue
		if !grid_node.has_method("conveyor_input"):
			continue
		if !grid_node.has_method("conveyor_accepts"):
			continue
		next_node = grid_node
		break

	for i in range(3):
		rot = Grid.fast_rotate(rot, 90)
		var nodes = Grid.instance.get_grid_nodes(pos + rot)
		for grid_node in nodes:
			if !grid_node.is_in_group("ConveyorOuput"):
				continue
			if Grid.fast_rotate(grid_node.grid_rotation(), 180) != rot:
				continue
			previous_nodes.append(grid_node)
			break

	_on_function_update()
	_update_children()

func _on_picked_up():
	_clear_connections()

func _on_function_update():
	if _locked:
		return

	for item_data in inventory.types_in_inventory():
		if _try_put_item_in_next_node(item_data):
			return

func _clear_connections():
	next_node = null
	previous_nodes.clear()
		

func _process_item(item: Item):
	_locked = true
	await get_tree().create_timer(conveyor_speed).timeout
	_locked = false
	_try_put_item_in_next_node(item.item_data)

func _try_put_item_in_next_node(item_data: ItemData) -> bool:
	if _locked:
		return false
	if next_node == null:
		return false
	if !next_node.conveyor_accepts(item_data):
		return false

	var item = inventory.remove_item(item_data)
	next_node.conveyor_input(item)
	_update_children()
	return true

		
func _update_children():
	var count = previous_nodes.size()
	for i in range(count):
		var index = (i + _last_grabbed_child + 1) % count
		previous_nodes[i].function_update.emit()
		if _locked:
			_last_grabbed_child = index
			return
