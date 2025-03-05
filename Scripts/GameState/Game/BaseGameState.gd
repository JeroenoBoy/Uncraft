class_name BaseGameState
extends State

var item_selector := false
var can_move_camera := false

var keybinds: Array[KeybindWidget.Data] = []

var _item_selector_screen: ItemSelectorScreen
var _keybinds_screen: KeybindScreen

func _on_first_activate():
	if item_selector:
		_item_selector_screen = UIManager.instance.get_screen("ItemSelector") as ItemSelectorScreen

	_keybinds_screen = UIManager.instance.get_screen("KeybindScreen") as KeybindScreen

	if !OS.has_feature("disable_cheats"):
		keybinds.append(KeybindWidget.Data.new("Open Cheats", "\\"))

func _on_activate(_state_data: Dictionary):
	EventBus.instance.ui_cancel.connect(_on_ui_cancel)
	if item_selector:
		_item_selector_screen.on_item_selected.connect(_on_item_selected)
		_item_selector_screen.show_screen()

	if can_move_camera:
		CameraController.instance.can_move = true

	_keybinds_screen.show_screen({ "keybinds": keybinds })

func _on_deactivate():
	EventBus.instance.ui_cancel.disconnect(_on_ui_cancel)
	if item_selector:
		_item_selector_screen.on_item_selected.disconnect(_on_item_selected)
		_item_selector_screen.hide_screen()
	
	if can_move_camera:
		CameraController.instance.can_move = false

	_keybinds_screen.hide_screen()

func _on_item_selected(selectable_item: SelectableItem):
	state_machine.change_state("PlaceItem", { "item": selectable_item.data.id, "selectable_item": selectable_item })

func _on_input(event: InputEvent) -> bool:
	if event.is_action_pressed("ui_cancel"):
		_on_ui_cancel()
		return false # Passing on escape to other functions too

	elif !OS.has_feature("disable_cheats") && event.is_action_pressed("open_cheats"):
		state_machine.change_state("CheatState")
		return true

	if item_selector:
		for i in range(9):
			if event.is_action_pressed("select_item_" + str(i+1)):
				_item_selector_screen.select_item(i)
				return true

	return false

func _on_ui_cancel():
	pass
