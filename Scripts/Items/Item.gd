class_name Item
extends Node2D

@export var item_data: ItemData

var _renderers: Dictionary = {}
var _parts: Array[ComplexItemPart] = []

static func create(item_data: ItemData) -> Item:
	var prefab = Globals.instance.item_prefab
	var instance = prefab.instantiate()

	if instance is not Item:
		push_error("Instance is not of type Item")
		return null

	var item = instance as Item
	item._set_data(item_data)

	Grid.instance.get_tree().current_scene.find_child("Items").add_child(item)

	return item

func has_part(part: ComplexItemPart) -> bool:
	return _parts.any(func(it): return it == part)

func has_all_parts(parts: Array[ComplexItemPart]) -> bool:
	for part in parts:
		if !has_part(part):
			return false
	return true

func has_none_parts(parts: Array[ComplexItemPart]) -> bool:
	for part in parts:
		if has_part(part):
			return false
	return true

func remove_part(part: ComplexItemPart):
	_parts.erase(part);

	var part_index = _parts.find(func(it): return it.layer == part.layer)
	if part_index == -1:
		_renderers[part.layer].queue_free()
		_renderers.erase(part.layer)
		return

	_parts[part.layer].texture = _parts[part_index].texture

func _set_data(item_data: ItemData):
	_clear_renderers()
	self.item_data = item_data
	_parts.clear()
	if item_data is ComplexItem:
		var complex_item = item_data as ComplexItem
		for complex_part in complex_item.items:
			_parts.append(complex_part)

	_create_renderer(-1, item_data.sprite)

	for part in _parts:
		if _renderers.has(part.layer):
			continue
		_create_renderer(part.layer, part.sprite)

func _clear_renderers():
	for renderer in _renderers.values():
		renderer.queue_free()
	_renderers.clear()
	
func _create_renderer(layer: int, texture: Texture2D):
	var instance = Sprite2D.new()
	instance.texture = texture
	add_child(instance)
	_renderers[layer] = instance
