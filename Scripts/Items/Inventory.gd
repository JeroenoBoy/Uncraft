class_name Inventory
extends Node2D

@export var max_size = 1;
@export var items: Array[Item] = []
@export var filter: Array[ItemFilter] = []

func add_item(item: Item) -> bool:
	return false
	
