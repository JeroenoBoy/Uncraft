class_name RecipeItem
extends Resource

@export var count = 1
@export var item_data: ItemData

@export var with_parts: Array[ComplexItemPart] = []
@export var without_parts: Array[ComplexItemPart] = []

func make_filter() -> Filter:
	if without_parts.is_empty() && without_parts.is_empty():
		var simple_filter = ItemFilter.new()
		simple_filter.item = item_data
		return simple_filter

	var filter = ComplexItemFilter.new()
	filter.item_data = item_data
	filter.has = with_parts
	filter.has_not = without_parts
	return filter

func get_item_parts() -> Array[ComplexItemPart]:
	return with_parts

func has_enough(inventory: Inventory) -> bool:
	if !inventory.has_items(item_data, count):
		return false

	if without_parts.is_empty() && without_parts.is_empty():
		return true

	var matched = 0;
	for item in inventory.get_items(item_data):
		if _does_item_match(item):
			matched += 1
			if matched >= count:
				break

	return matched >= count

func transfer(input_inventory: Inventory, output_inventory: Inventory):
	var items_left = count
	for item in input_inventory.get_items(item_data):
		if !_does_item_match(item):
			continue

		input_inventory.remove_specific_item(item)
		output_inventory.add_item(item)
		items_left -= 1
		if items_left == 0:
			break

func _does_item_match(item: Item) -> bool:
	return item.has_all_parts(with_parts) && item.has_none_parts(without_parts)
