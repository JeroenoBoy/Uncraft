class_name MachineInput
extends GridNode

@export var inventory: Inventory

var target_node: GridNode

func _ready() -> void:
	super._ready()
	tile_update.connect(_on_tile_update)
	inventory.item_removed.connect(_on_item_removed)

func conveyor_accepts(item: Item) -> bool:
	return inventory.can_hold_item(item)

func conveyor_input(item: Item) -> bool:
	return inventory.add_item(item)

func _on_tile_update():
	var pos = grid_position()
	var iRot = grid_position()
	var rot = Grid.fast_rotate(iRot, 180)
	target_node = null

	var buildings_infront = Grid.instance.get_grid_nodes(pos + rot)
	for building in buildings_infront:
		if !building.is_in_group("ConveyorOuput"):
			continue
		if building.grid_rotation() != iRot:
			continue
		target_node = building
		break

	if target_node != null:
		target_node.function_update.emit()

func _on_item_removed(_item: Item):
	if target_node != null:
		target_node.function_update.emit()
