class_name Inventory
extends Node2D

signal item_added(item: Item)

@export var max_size = 1
@export var max_items = -1
@export var items: Dictionary = {}
@export var filter: Array[ItemFilter] = []
@export var items_visible = false;

var total_items = 0

func _exit_tree() -> void:
	for v in items.values():
		for item in v:
			item.queue_free()

func can_hold(item_data: ItemData) -> bool:
	if max_items > -1:
		if total_items + 1 > max_items:
			return false

	if filter.size() != 0 && !filter.any(func(it): return it.item_data == item_data):
		return false

	if items.has(item_data):
		var items_in_inventory = items[item_data] as Array[Item];
		if item_data.max_size > items_in_inventory.size() + 1:
			return false
	
	if items.size() >= max_size:
		return false

	return true

func add_item(item: Item) -> bool:
	if !can_hold(item.item_data):
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

func remove_item(item_data: ItemData) -> Item:
	if !items.has(item_data):
		return null

	var items_in_inventory = items[item_data] as Array[Item]
	var item = items_in_inventory.pop_front()
	total_items -= 1

	if items_in_inventory.size() == 0:
		items.erase(item_data)
	
	return item
