class_name ItemSelectorScreen
extends UIScreen

signal on_item_selected(selectable_item: SelectableItem)

func _first_show():
	for child in find_children("*", "SelectableItem", true, false):
		var selectable = child as SelectableItem
		selectable.on_pressed.connect(_on_item_pressed)

func _show(_screen_data: Dictionary):
	visible = true

func _hide():
	visible = false

func _on_item_pressed(selectable_item: SelectableItem):
	on_item_selected.emit(selectable_item)
