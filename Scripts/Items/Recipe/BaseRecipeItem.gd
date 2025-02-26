class_name BaseRecipeItem
extends Resource

func make_filter() -> Filter:
	return null

func has_enough(inventory: Inventory) -> bool:
	return false;

func transfer(input_inventory: Inventory, output_inventory: Inventory):
	pass
