class_name Inventory
extends Node2D

signal item_added(item: Item)
signal item_removed(item: Item)

@export var max_size = 1
@export var max_items = -1
@export var items: Dictionary = {}
@export var filter: Array[Filter] = []
@export var items_visible = false;

var locked = false
var total_items = 0

func _exit_tree() -> void:
	for v in items.values():
		for item in v:
			item.queue_free()

func has_items(item_data: ItemData, count = 1) -> bool:
	if !items.has(item_data):
		return false
	return items[item_data].size() >= count

func is_full() -> bool:
	return total_items >= max_size

func is_not_empty() -> bool:
	return total_items > 0

func is_empty() -> bool:
	return total_items == 0

func can_hold(item_data: ItemData) -> bool:
	if locked:
		return false
	
	if max_items > -1:
		if total_items + 1 > max_items:
			return false

	if filter.size() != 0 && !filter.any(func(it): return it.item_data == item_data):
		return false

	if items.has(item_data):
		var items_in_inventory = items[item_data] as Array[Item];
		if item_data.stack_size > items_in_inventory.size() + 1:
			return false
	
	if items.size() >= max_size:
		return false

	return true

func can_hold_item(item: Item) -> bool:
	if locked:
		return false

	if max_items > -1:
		if total_items + 1 > max_items:
			return false

	if filter.size() != 0 && !filter.any(func(it): return it.check(item)):
		return false

	var item_data = item.item_data
	if items.has(item_data):
		var items_in_inventory = items[item_data] as Array[Item];
		if item_data.stack_size > items_in_inventory.size() + 1:
			return false
	
	if items.size() >= max_size:
		return false

	return true
	

func types_in_inventory() -> Array[ItemData]:
	var array: Array[ItemData] = []
	array.append_array(items.keys())
	return array

func add_item(item: Item) -> bool:
	if !can_hold_item(item):
		return false
	add_item_skip_checks(item)
	return true
	
func add_item_skip_checks(item: Item):
	var item_data = item.item_data
	if !items.has(item_data):
		items[item_data] = []

	item.visible = items_visible
	
	items[item_data].append(item)
	total_items += 1
	item_added.emit(item)

func get_item(item_data: ItemData, with_parts: Array[ComplexItemPart] = [], without_parts: Array[ComplexItemPart] = []) -> Item:
	if !items.has(item_data):
		return null

	for item in items[item_data]:
		if item.has_all_parts(with_parts) && item.has_none_parts(without_parts):
			return item

	return null

func get_items(item_data: ItemData) -> Array[Item]:
	var arr: Array[Item] = []
	if !items.has(item_data):
		return arr
	arr.assign(items[item_data])
	return arr

func get_unique_items() -> Array[Item]:
	var out: Array[Item] = []
	for item_data in items.keys():
		if item_data is ComplexItem:
			out.append_array(items[item_data])
		else:
			var item = get_item(item_data)
			out.append(item)
	return out

func get_item_other_can_hold(other_inventory: Inventory):
	for item_data in items.keys():
		if item_data is ComplexItem:
			for item in items[item_data]:
				if !other_inventory.can_hold_item(item):
					continue
				return item
		else:
			var item = get_item(item_data)
			if !other_inventory.can_hold_item(item):
				continue
			return item
				
	return null

func remove_random_item() -> Item:
	if items.is_empty():
		return null
	return remove_item(items.keys().pick_random())

func remove_item(item_data: ItemData) -> Item:
	if !items.has(item_data):
		return null

	var items_in_inventory = items[item_data] as Array[Item]
	var item = items_in_inventory.pop_front()
	total_items -= 1

	if items_in_inventory.size() == 0:
		items.erase(item_data)

	item_removed.emit(item)
	return item

func remove_specific_item(item: Item) -> bool:
	if !items.has(item.item_data):
		return false

	var items_in_inventory = items[item.item_data] as Array[Item]
	if !items_in_inventory.has(item):
		return false

	items_in_inventory.erase(item)
	total_items -= 1

	if items_in_inventory.size() == 0:
		items.erase(item.item_data)

	item_removed.emit(item)
	return true

func set_filters(filters: Array[Filter]):
	filter.clear()
	filter.append_array(filters)

func clear_filters():
	filter.clear()

func clear_inventory():
	for item_data in types_in_inventory():
		while items.has(item_data):
			var item = remove_item(item_data)
			item.queue_free()
