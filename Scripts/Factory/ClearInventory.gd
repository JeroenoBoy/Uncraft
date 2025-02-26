class_name ClearInventory
extends Node2D

@onready var inventory: Inventory = $Inventory

func _ready() -> void:
	inventory.item_added.connect(_on_item_added)

func _on_item_added(_item: Item):
	inventory.clear_inventory()



