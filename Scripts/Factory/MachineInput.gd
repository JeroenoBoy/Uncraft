class_name MachineInput
extends GridNode

@export var inventory: Inventory

func _ready() -> void:
	super._ready()
	tile_update.connect(_on_tile_update)

func conveyor_accepts(item_data: ItemData) -> bool:
	return inventory.can_hold(item_data)

func conveyor_input(item: Item) -> bool:
	return inventory.add_item(item)

func _on_tile_update():
	var rot = Grid.fast_rotate(grid_rotation(), 180)
