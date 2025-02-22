class_name Inventory
extends Node2D

@export var max_size = 1
@export var max_items = -1
@export var items: Array[Item] = []
@export var filter: Array[ItemFilter] = []

var items_in_inventory = 0

func add_item(item: Item) -> bool:
	
	if max_items > -1:
		if item.count + items_in_inventory > max_items:
			return false

	var item_data = item.item_data
	if filter.size() != 0 && !filter.any(func(it): return it.item_data == item_data):
		return false

	var item_in_inventory = items.find(func(it): return it.item_data == item_data)
	if item_in_inventory != null:
		if item_data.max_size > item_in_inventory.count + item.count:
			return false

	elif items.count >= max_size:
		return false
	
	return false
	
func add_item_skip_checks(item: Item):
	var item_data = item.item_data
	items_in_inventory += item.count
	if item_data is ComplexItem:
		items.append(item)
		return

	var item_in_inventory = items.find(func(it): return it.item_data == item_data)
	if item_in_inventory == null:
		items.append(item)
	else:
		item_in_inventory.count += item.count
		item.queue_free()

func remove_item(item_data: ItemData, count = 1) -> Item:
	var item_in_inventory = items.find(func(it): return it.item_data == item_data)
	if item_in_inventory == null:
		return null

	if item_in_inventory.count <= count:
		items.erase(item_in_inventory)
		items_in_inventory -= item_in_inventory.count
		return item_in_inventory

	items_in_inventory -= count
	item_in_inventory.count -= count
	return Item.create(item_data, count)
