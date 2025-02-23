class_name BaseGameState
extends State

var _item_selector = false
var _item_selector_screen: ItemSelectorScreen

func _on_first_activate():
	if _item_selector:
		_item_selector_screen = UIManager.instance.get_screen("ItemSelector") as ItemSelectorScreen

func _on_activate(state_data: Dictionary):
	if _item_selector:
		_item_selector_screen.on_item_selected.connect(_on_item_selected)
		_item_selector_screen.show_screen()
	pass

func _on_deactivate():
	if _item_selector:
		_item_selector_screen.on_item_selected.disconnect(_on_item_selected)
		_item_selector_screen.hide_screen()
	pass

func _on_item_selected(item: PlaceableItem):
	state_machine.change_state("PlaceItem", { "item": item })
