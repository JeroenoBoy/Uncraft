class_name DisplayItem
extends Control

@export var part_scene: PackedScene

@onready var icon: TextureRect = $Icon
@onready var countText: Label = $Count
@onready var container: GridContainer = $GridContainer

func set_item(item_data: ItemData, count = 1, parts: Array[ComplexItemPart] = [], _bad_parts: Array[ComplexItemPart] = []):
	_clear_container()
	icon.texture = item_data.get_icon()

	countText.visible = count > 1
	countText.text = str(count)

	for part in parts:
		_add_part(part)

func set_count(count: int):
	countText.text = str(count)

func _clear_container():
	for n in container.get_children():
		n.queue_free()

func _add_part(part: ComplexItemPart):
	var instance = part_scene.instantiate()
	container.add_child(instance)
	instance.find_child("Icon").texture = part.icon
