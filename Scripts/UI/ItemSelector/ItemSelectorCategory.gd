class_name ItemSelectorCategory
extends Control

@export var folder = "res://Resources/Factory"
@export var selectableItemScene: PackedScene
@export var container: Control

func _ready() -> void:
	var access = DirAccess.open(folder)
	if !access.dir_exists(folder):
		push_error("Directory '"+folder+"' does not exist")
		return

	for file in access.get_files():
		var resource = ResourceLoader.load(folder + "/" + file)
		if resource is not PlaceableItem:
			continue

		var item = resource as PlaceableItem
		var selectableItem = selectableItemScene.instantiate() as SelectableItem
		container.add_child(selectableItem)
		selectableItem.set_item(item)
	
