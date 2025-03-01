class_name GameDefaultState
extends BaseGameState

const LONG_PRESS_TIME = .5
var press_time = -1
var selected_node_at_press = Vector2i.ZERO

func _init():
	item_selector = true
	can_move_camera = true

func _on_activate(state_data: Dictionary):
	super._on_activate(state_data)
	press_time = -1
	selected_node_at_press = Vector2i.ZERO

func _on_deactivate():
	super._on_deactivate()

func _update(delta: float):
	super._update(delta)
	_process_long_press(delta)

func _process_long_press(delta: float):
	if UIManager.instance.is_mouse_over_ui:
		press_time = -1
		selected_node_at_press = Vector2i.ZERO
		return

	if Input.is_action_just_pressed("build_pickup"):
		press_time = 0
		selected_node_at_press = Grid.grid_mouse_pos()

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
		if building == null:
			press_time = -1
		else:
			state_machine.change_state("MoveBuilding", { "building": building, "mode": "Drag" })
		return

	if Input.is_action_just_released("build_pickup"):
		press_time = -1
		var building = Grid.instance.get_grid_node(selected_node_at_press)
		if building == null:
			return

		var clickAction = building.find_child("ClickAction", false)
		if clickAction != null:
			clickAction.execute(state_machine)
		elif building.movable:
			state_machine.change_state("MoveBuilding", { "building": building })
