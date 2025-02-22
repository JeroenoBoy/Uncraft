class_name ComplexItemFilter
extends Filter

@export var item_data: ComplexItem
@export var has: Array[ComplexItemPart] = []
@export var has_not: Array[ComplexItemPart] = []

func check(item: Item) -> bool:
	if item.item_data != item_data:
		return false
	
	for part in has:
		if !item.has_node(part.name):
			return false
	
	for part in has_not:
		if item.has_node(part.name):
			return false
	
	return true
