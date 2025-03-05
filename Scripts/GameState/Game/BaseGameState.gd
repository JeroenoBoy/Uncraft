class_name BaseGameState
extends State

var item_selector := false
var can_move_camera := false
var _item_selector_screen: ItemSelectorScreen

func _on_first_activate():
	if item_selector:
		_item_selector_screen = UIManager.instance.get_screen("ItemSelector") as ItemSelectorScreen

func _on_activate(_state_data: Dictionary):
	EventBus.instance.ui_cancel.connect(_on_ui_cancel)
	if item_selector:
		_item_selector_screen.on_item_selected.connect(_on_item_selected)
		_item_selector_screen.show_screen()

	if can_move_camera:
		CameraController.instance.can_move = true

func _on_deactivate():
	EventBus.instance.ui_cancel.disconnect(_on_ui_cancel)
	if item_selector:
		_item_selector_screen.on_item_selected.disconnect(_on_item_selected)
		_item_selector_screen.hide_screen()
	
	if can_move_camera:
		CameraController.instance.can_move = false

func _on_item_selected(selectable_item: SelectableItem):
	state_machine.change_state("PlaceItem", { "item": selectable_item.data.id, "selectable_item": selectable_item })

func _on_input(event: InputEvent):

	if event.is_action_pressed("ui_cancel"):
		_on_ui_cancel()
	elif event.is_action_pressed("open_cheats"):
		state_machine.change_state("CheatState")

func _on_ui_cancel():
	pass
