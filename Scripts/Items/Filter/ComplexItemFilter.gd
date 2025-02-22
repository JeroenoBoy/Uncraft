class_name ComplexItemFilter
extends Filter

@export var itemData: ComplexItem
@export var has: Array[ComplexItemPart] = []
@export var hasNot: Array[ComplexItemPart] = []

func check(item: Item) -> bool:
	if item.itemData != itemData:
		return false
	
	for part in has:
		if !item.has_node(part.name):
			return false
	
	for part in hasNot:
		if item.has_node(part.name):
			return false
	
	return true
