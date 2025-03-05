class_name BaseMoveBuildingState
extends BaseGameState

enum Mode {
	Default,
	Drag
}

var object: GridNode
var current_pos: Vector2i
var current_rotation = 0.0
var can_place = false
var mode = Mode.Default

var delete_screen: DeleteScreen

func _init() -> void:
	can_move_camera = true

func _on_first_activate():
	super._on_first_activate()
	delete_screen = UIManager.instance.get_screen("DeleteScreen") as DeleteScreen
	keybinds.append(KeybindWidget.Data.new("Place", "LMB"))
	keybinds.append(KeybindWidget.Data.new("Cancel", "ESC"))
	keybinds.append(KeybindWidget.Data.new("Rotate", "Q"))
	keybinds.append(KeybindWidget.Data.new("Rotate", "E"))

func _on_activate(state_data: Dictionary):
	super._on_activate(state_data)

	mode = Mode.Default
	if state_data.has("mode"):
		mode = Mode.get(state_data["mode"])
		Input.set_default_cursor_shape(Input.CURSOR_DRAG)

	delete_screen.delete_pressed.connect(_on_delete)

func _on_deactivate():
	super._on_deactivate()
	delete_screen.hide_screen()
	delete_screen.delete_pressed.disconnect(_on_delete)

	if mode == Mode.Drag:
		Input.set_default_cursor_shape(Input.CURSOR_ARROW)
		

func reset_position_to_mouse():
	current_rotation = 0
	current_pos = Grid.grid_mouse_pos(object)

func reset_position_to_building(grid_node: GridNode):
	current_rotation = grid_node.global_rotation_degrees
	current_pos = Grid.world_to_grid(grid_node.position)

func set_object(grid_node: GridNode):
	if grid_node.is_on_grid:
		push_error("GridNode cannot be placed on a grid")
		return

	object = grid_node
	move_object(current_pos)
	rotate_object(current_rotation)
	_check_valid_position()

	if object.removable:
		delete_screen.show_screen()
	else:
		delete_screen.hide_screen()

func move_object(position: Vector2i):
	current_pos = position
	object.position = Grid.grid_to_world(current_pos)
	_check_valid_position()

func rotate_object(rotation: float):
	rotation = ((int(floor(rotation / 90)) % 4 + 4) % 4) * 90
	current_rotation = rotation
	object.global_rotation_degrees = rotation
	_check_valid_position()

func _on_input(event: InputEvent) -> bool:
	if super._on_input(event):
		return true

	if event.is_action_pressed("build_cancel"):
		_on_cancel()
		return true
	
	if object == null:
		return false
		
	if object.removable && event.is_action_pressed("build_delete"):
		_on_delete()
		return true

	match mode:
		Mode.Default:
			if can_place && event.is_action_pressed("build_place"):
				_on_place()
				return true
		Mode.Drag:
			if event.is_action_released("build_place"):
				if !can_place:
					_on_cancel()
				elif delete_screen.is_mouse_over_screen:
					_on_delete()
				else:
					_on_place()
				return true
		_:
			push_error("Move mode ", mode, " is not implemented")

	if object.rotatable && event.is_action_pressed("build_rotate_clockwise"):
		rotate_object(current_rotation + 90)
		return true

	if object.rotatable && event.is_action_pressed("building_rotate_anti_clockwise"):
		rotate_object(current_rotation - 90)
		return true

	return false


func _update(delta: float):
	super._update(delta)

	var grid_pos = Grid.grid_mouse_pos(object)
	if grid_pos != current_pos:
		move_object(grid_pos)

func _check_valid_position():
	can_place = Grid.instance.is_spot_occupied(object)

func _on_place():
	push_error("on_place must be overridden")
	pass

func _on_cancel():
	push_error("on_cancel must be overridden")
	pass

func _on_delete():
	push_error("on_delete must be overridden")
	pass
