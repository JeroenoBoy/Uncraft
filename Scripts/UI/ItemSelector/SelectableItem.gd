class_name SelectableItem
extends Button

@onready var image: TextureRect = find_child("Image", true)
@onready var nameContainer: Label = find_child("Label", true)

var item: PlaceableItem

func set_item(item: PlaceableItem):
	image.texture = item.sprite
	nameContainer.text = item.name
	self.item = item
