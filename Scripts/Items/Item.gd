class_name Item
extends Node2D

@export var count = 1
@export var item_data: ItemData

var renderers: Array[Sprite2D] = []


static func create(item_data: ItemData, count = 1) -> Item:
	var prefab = Globals.instance.item_prefab
	var instance = prefab.instantiate()

	if instance is not Item:
		push_error("Instance is not of type Item")
		pass

	var item = instance as Item
	item.count = max(count, 1)
	item.set_data(item_data)

	return null
	

func set_data(item_data: ItemData):
	_clear_renderers()
	self.item_data = item_data
	if item_data is ComplexItem:
		return

	_create_renderer(item_data.sprite)


func _clear_renderers():
	for renderer in renderers:
		renderer.queue_free()
	
func _create_renderer(texture: Texture2D):
	var instance = Sprite2D.new()
	instance.texture = texture
	add_child(instance)
	renderers.append(instance)
