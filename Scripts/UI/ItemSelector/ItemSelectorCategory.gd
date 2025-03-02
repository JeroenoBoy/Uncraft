class_name ItemSelectorCategory
extends Control

@export var items: Array[PlaceableItem]
@export var selectableItemScene: PackedScene
@export var container: Control

func _ready() -> void:
	for item in items:
		var selectableItem = selectableItemScene.instantiate() as SelectableItem
		container.add_child(selectableItem)
		selectableItem.set_item(SelectableItem.SelectData.new(item, item.name, item.sprite, item.ui_icon_scale))

	visibility_changed.connect(_on_visibility_changed)
	
func _on_visibility_changed():
	if !is_visible_in_tree():
		return

	for child in container.get_children():
		var selectable_item = child as SelectableItem
		var placable_item = selectable_item.data.id as PlaceableItem
		child.visible = child.data.id.condition == null || child.data.id.condition.check()

		if placable_item.place_limit != null && placable_item.placed_store != null:
			var max_count = placable_item.place_limit.get_value()
			var current = placable_item.placed_store.get_objects().size()
			selectable_item.data.max_count = max_count
			selectable_item.set_current_count(max_count - current)
