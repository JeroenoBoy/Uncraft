class_name ItemFilter
extends Filter

@export var item: ItemData

func check(item: Item) -> bool:
	return item.itemData == item
