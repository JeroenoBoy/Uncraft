class_name Manufacturer
extends Node2D

@export var recipes: Array[Recipe] = []
@export var outputs: Array[MachineOutput] = []

@onready var input_inventory: Inventory = $InputInventory
@onready var processing_inventory: Inventory = $ProcessingInventory

var selected_recipe: Recipe
var locked: bool

func _ready() -> void:
	set_recipe(recipes[0])
	input_inventory.item_added.connect(_on_item_added)
	for output in outputs:
		output.item_removed.connect(_on_item_removed_from_output)

func _on_item_added(_item: Item):
	_try_craft_recipe()

func _on_item_removed_from_output(_item: Item):
	_try_craft_recipe()

func set_recipe(recipe: Recipe):
	input_inventory.clear_inventory()
	processing_inventory.clear_inventory()
	selected_recipe = recipe
	input_inventory.set_filters(selected_recipe.make_filters())

func _try_craft_recipe() -> bool:
	if locked:
		return false
	if !processing_inventory.is_empty():
		return false
	if outputs.any(func(it): return it.inventory.is_full()):
		return false

	for input in selected_recipe.inputs:
		if !input.has_enough(input_inventory):
			return false

	_crafting_loop()

	return true

func _crafting_loop():
	locked = true

	for recipe_item in selected_recipe.inputs:
		recipe_item.transfer(input_inventory, processing_inventory)

	for item_transform in selected_recipe.output:
		item_transform.process(processing_inventory)

	await get_tree().create_timer(selected_recipe.craft_time).timeout

	var current_ouput_index = 0
	while processing_inventory.is_not_empty():
		var output = outputs[current_ouput_index]
		var item = processing_inventory.get_item_other_can_hold(output.inventory)
		if item == null:
			continue

		processing_inventory.remove_specific_item(item)
		output.inventory.add_item_skip_checks(item)
		current_ouput_index = (current_ouput_index + 1) % outputs.size()

	locked = false

	_try_craft_recipe()
