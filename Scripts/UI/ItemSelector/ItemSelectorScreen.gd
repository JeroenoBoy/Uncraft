class_name ItemSelectorScreen
extends UIScreen

signal on_item_selected(selectable_item: SelectableItem)

@export var button_container: Control

func _first_show():
	for child in find_children("*", "SelectableItem", true, false):
		var selectable = child as SelectableItem
		selectable.on_pressed.connect(_on_item_pressed)

func _show(_screen_data: Dictionary):
	visible = true

func _hide():
	visible = false

func select_item(index: int):
	var children = button_container.get_children()
	if children.size() <= index:
		return

	var i = -1
	for child in children:
		if !child.visible:
			continue
		i += 1
		if i != index:
			continue
		
		var btn := child as Button
		btn.grab_focus()
		if btn.has_method("_pressed"):
			btn._pessed()
		btn.pressed.emit()
		return

func _on_item_pressed(selectable_item: SelectableItem):
	on_item_selected.emit(selectable_item)
