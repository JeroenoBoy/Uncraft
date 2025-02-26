class_name RecipeItem
extends BaseRecipeItem

@export var count = 1
@export var item_data: ItemData

func make_filter() -> Filter:
	var filter = ItemFilter.new()
	filter.item = item_data
	return filter

func has_enough(inventory: Inventory) -> bool:
	return inventory.has_items(item_data, count)

func transfer(input_inventory: Inventory, output_inventory: Inventory):
	for i in range(count):
		output_inventory.add_item_skip_checks(input_inventory.remove_item(item_data))
