class_name Generator
extends Timer

@export var item_data: ItemData
@export var output: MachineOutput

func _on_timeout() -> void:
	if !output.inventory.can_hold(item_data):
		return

	var item = Item.create(item_data)
	output.inventory.add_item_skip_checks(item)

func _on_car_generator_placed() -> void:
	start()

func _on_car_generator_picked_up() -> void:
	stop()
