class_name BaseGameState
extends State

var item_selector = false
var can_move_camera = false
var _item_selector_screen: ItemSelectorScreen

func _on_first_activate():
	if item_selector:
		_item_selector_screen = UIManager.instance.get_screen("ItemSelector") as ItemSelectorScreen

func _on_activate(_state_data: Dictionary):
	if item_selector:
		_item_selector_screen.on_item_selected.connect(_on_item_selected)
		_item_selector_screen.show_screen()

	if can_move_camera:
		CameraController.instance.can_move = true

func _on_deactivate():
	if item_selector:
		_item_selector_screen.on_item_selected.disconnect(_on_item_selected)
		_item_selector_screen.hide_screen()
	
	if can_move_camera:
		CameraController.instance.can_move = false

func _on_item_selected(item: PlaceableItem):
	state_machine.change_state("PlaceItem", { "item": item })

func _update(_delta: float):
	if Input.is_action_just_pressed("ui_cancel"):
		_on_ui_cancel()
		return

	if Input.is_action_just_pressed("open_cheats") && !OS.has_feature("disable_cheats"):
		state_machine.change_state("CheatState")
		return

func _on_ui_cancel():
	pass
