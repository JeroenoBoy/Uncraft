class_name MachineOutput
extends GridNode

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

func _on_tile_update():
	output_node = null
	var pos = grid_position()
	var rot = grid_rotation()

	print("Output position ", pos, " rot ", rot)
	print("Checking position position ", pos + rot)

	_clear_connections()
	var buildings_infront = Grid.instance.get_grid_nodes(pos + rot)
	for building in buildings_infront:
		print("Found ", building.name)
		if building.has_method("conveyor_input") && building.has_method("conveyor_accepts"):
			print("Set target building")
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
		if !output_node.conveyor_accepts(check_item):
			return

		inventory.remove_specific_item(check_item)
		output_node.conveyor_input(check_item)
		return
		

	for item_data in inventory.types_in_inventory():
		if item_data is ComplexItem:
			for item in inventory.get_items(item_data):
				if !output_node.conveyor_accepts(item):
					continue
				
				inventory.remove_specific_item(item)
				output_node.conveyor_input(item)
				return

		else:
			var item = inventory.get_item(item_data)
			if !output_node.conveyor_accepts(item):
				continue

			inventory.remove_specific_item(item)
			output_node.conveyor_input(item)
			return
