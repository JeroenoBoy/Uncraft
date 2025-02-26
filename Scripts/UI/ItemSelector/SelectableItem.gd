class_name SelectableItem
extends Button

@onready var image: TextureRect = find_child("Image", true)
@onready var nameContainer: Label = find_child("Label", true)

signal on_pressed(item: SelectableItem)

var item: PlaceableItem

func set_item(item: PlaceableItem):
	image.texture = item.sprite
	image.scale = image.scale * item.ui_icon_scale
	nameContainer.text = item.name
	self.item = item

func _on_pressed() -> void:
	on_pressed.emit(self)
	
