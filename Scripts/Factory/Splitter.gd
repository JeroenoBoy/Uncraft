class_name Splitter
extends Node2D

@export var inputs: Array[MachineInput]
@export var outputs: Array[MachineOutput]

var locked = false
var next_output_index = 0
var next_input_index = 0

func _ready():
	for output in outputs:
		output.tile_update.connect(_on_tile_update)
		output.function_update.connect(_on_function_update)
		output.item_removed.connect(_on_item_removed_from_conveyor)
	
	for input in inputs:
		input.inventory.item_added.connect(_on_item_added)

func _on_item_removed_from_conveyor(_item: Item):
	_try_split()

func _on_item_added(_item: Item):
	_try_split()

func _on_tile_update():
	_try_split()

func _on_function_update():
	_try_split()
	
func _try_split():
	var input_count = inputs.size()
	var output_count = outputs.size()
	
	for i in range(input_count):
		var i_i = (i + next_input_index) % input_count
		var process_inventory = inputs[i_i].inventory
		if process_inventory.is_empty():
			continue

		var types = process_inventory.types_in_inventory()
		var item = process_inventory.get_item(types[0])

		for y in range(output_count):
			var o_i = (y + next_output_index) % output_count
			var output = outputs[o_i]
			if !output.has_output():
				continue

			if !output.inventory.can_hold_item(item):
				continue

			process_inventory.remove_specific_item(item)
			output.inventory.add_item(item)
			next_input_index = (i_i + 1) % input_count
			next_output_index = (o_i + 1) % output_count
			_try_split()
			return

	for input in inputs:
		input.function_update.emit()

	
