class_name MachineInput
extends GridNode

@export var inventory: Inventory

func _ready() -> void:
	super._ready()
	tile_update.connect(_on_tile_update)

func conveyor_input(item: Item) -> bool:
	return inventory.add_item(item)

func _on_tile_update():
	var rot = Grid.fast_rotate(rotation(), 180)
