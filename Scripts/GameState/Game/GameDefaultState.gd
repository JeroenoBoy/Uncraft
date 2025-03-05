class_name GameDefaultState
extends BaseGameState

const LONG_PRESS_TIME = .5
var press_time = -1
var selected_node_at_press = Vector2i.ZERO

var delete_screen: DeleteScreen

func _init():
	item_selector = true
	can_move_camera = true

func _on_first_activate():
	super._on_first_activate()
	delete_screen = UIManager.instance.get_screen("DeleteScreen") as DeleteScreen
	keybinds.append(KeybindWidget.Data.new("Delete mode", "X"))
	keybinds.append(KeybindWidget.Data.new("Select Building", "LMB"))

func _on_activate(state_data: Dictionary):
	super._on_activate(state_data)
	press_time = -1
	selected_node_at_press = Vector2i.ZERO
	delete_screen.show_screen()
	delete_screen.delete_pressed.connect(_on_delete_icon_pressed)

func _on_deactivate():
	super._on_deactivate()
	delete_screen.hide_screen()
	delete_screen.delete_pressed.disconnect(_on_delete_icon_pressed)

func _on_input(event: InputEvent):
	if super._on_input(event):
		return true

	if event.is_action_pressed("build_pickup"):
		press_time = 0
		selected_node_at_press = Grid.grid_mouse_pos()
		return true

	if event.is_action_released("build_pickup"):
		if press_time == -1:
			return true

		var building = Grid.instance.get_grid_node(selected_node_at_press)
		_reset_press()
		if building == null: return true
		var click_action = building.find_child("ClickAction", false)

		if click_action != null:
			click_action.execute(state_machine)
		else:
			state_machine.change_state("MoveBuilding", { "building": building })
		return true

	if event.is_action_pressed("build_delete"):
		state_machine.change_state("DeleteMode")
		return true

	return false
			
func _update(delta: float):
	super._update(delta)
	_process_long_press(delta)

func _process_long_press(delta: float):
	if press_time == -1:
		return

	press_time += delta
	if Grid.grid_mouse_pos() != selected_node_at_press:
		var building = Grid.instance.get_grid_node(selected_node_at_press)
		if building != null && building.movable:
			state_machine.change_state("MoveBuilding", { "building": building, "mode": "Drag" })
			return

	if press_time > LONG_PRESS_TIME:
		var building = Grid.instance.get_grid_node(selected_node_at_press)
		if building != null && building.movable:
			state_machine.change_state("MoveBuilding", { "building": building, "mode": "Drag" })
		press_time = -1
		return

func _reset_press():
	press_time = -1
	selected_node_at_press = Vector2i.ZERO

func _on_delete_icon_pressed():
	state_machine.change_state("DeleteMode")
