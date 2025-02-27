class_name BaseRecipeItem
extends Resource

@export var count = 1
@export var item_data: ComplexItem

func make_filter() -> Filter:
	return null

func get_item_parts() -> Array[ComplexItemPart]:
	return []

func has_enough(inventory: Inventory) -> bool:
	return false;

func transfer(input_inventory: Inventory, output_inventory: Inventory):
	pass
