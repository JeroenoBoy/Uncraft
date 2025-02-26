class_name MachineOutput
extends GridNode

signal item_removed(item: Item)

@export var filter: Array[Filter]
@onready var inventory: Inventory = $Inventory

var output_node: GridNode

func _ready() -> void:
	super._ready()
	inventory.set_filters(filter)
	tile_update.connect(_on_tile_update)
	picked_up.connect(_on_picked_up)
	function_update.connect(_on_function_update)
	inventory.item_added.connect(_on_inventory_item_added)
	inventory.item_removed.connect(func(item): item_removed.emit(item))

func _on_tile_update():
	output_node = null
	var pos = grid_position()
	var rot = grid_rotation()

	_clear_connections()
	var buildings_infront = Grid.instance.get_grid_nodes(pos + rot)
	for building in buildings_infront:
		if !building.has_method("conveyor_can_make_link"):
			continue
		if !building.conveyor_can_make_link(self):
			continue
		if !building.has_method("conveyor_input") || !building.has_method("conveyor_accepts"):
			continue
		output_node = building
		break

	_try_output_item()

func _on_picked_up():
	_clear_connections()

func _on_function_update():
	_try_output_item()

func _on_inventory_item_added(item: Item):
	_try_output_item(item)

func has_output() -> bool:
	return output_node != null

func _clear_connections():
	output_node = null

func _try_output_item(check_item: Item = null):
	if output_node == null:
		return

	if check_item != null:
		if !output_node.conveyor_accepts(check_item):
			return

		inventory.remove_specific_item(check_item)
		output_node.conveyor_input(check_item)
		return
		
	for item in inventory.get_unique_items():
		if !output_node.conveyor_accepts(item):
			continue

		inventory.remove_specific_item(item)
		output_node.conveyor_input(item)
		return
