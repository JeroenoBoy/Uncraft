class_name RecipeItem
extends BaseRecipeItem

func make_filter() -> Filter:
	var filter = ItemFilter.new()
	filter.item = item_data
	return filter

func get_count() -> int:
	return count

func get_item_data() -> ItemData:
	return item_data

func has_enough(inventory: Inventory) -> bool:
	return inventory.has_items(item_data, count)

func transfer(input_inventory: Inventory, output_inventory: Inventory):
	for i in range(count):
		output_inventory.add_item_skip_checks(input_inventory.remove_item(item_data))
