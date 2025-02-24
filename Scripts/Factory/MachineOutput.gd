class_name MachineOutput
extends GridNode

@export var filter: Array[Filter]
@onready var inventory: Inventory = $Inventory

var output_node: GridNode

func _ready() -> void:
	super._ready()
	inventory.filter = filter
	tile_update.connect(_on_tile_update)
	picked_up.connect(_on_picked_up)
	function_update.connect(_on_function_update)
	inventory.item_added.connect(_on_inventory_item_added)

func _on_tile_update():
	var pos = grid_position()
	var rot = grid_rotation()

	_clear_connections()
	var buildings_infront = Grid.instance.get_grid_nodes(pos + rot)
	for building in buildings_infront:
		if building.has_method("conveyor_input") && building.has_method("conveyor_accepts"):
			output_node = building
			break
	
	_try_output_item()

func _on_picked_up():
	_clear_connections()

func _on_function_update():
	_try_output_item()

func _on_inventory_item_added(item: Item):
	_try_output_item(item)

func _clear_connections():
	output_node = null

func _try_output_item(check_item: Item = null):
	if output_node == null:
		return

	if check_item != null:
		if !output_node.conveyor_accepts(check_item.item_data):
			return

		var item = inventory.remove_item(check_item.item_data)
		output_node.conveyor_input(item)
		return
		

	var item_types = inventory.types_in_inventory()
	for item_data in item_types:
		if !output_node.conveyor_accepts(item_data):
			continue

		var item = inventory.remove_item(item_data)
		output_node.conveyor_input(item)
		return
