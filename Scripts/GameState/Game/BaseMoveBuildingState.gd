class_name BaseMoveBuildingState
extends BaseGameState

var object: GridNode
var current_pos: Vector2i
var current_rotation = 0.0
var can_place = false

var delete_screen: DeleteScreen

func _on_first_activate():
	super._on_first_activate()
	delete_screen = UIManager.instance.get_screen("DeleteScreen") as DeleteScreen

func _on_activate(_state_data: Dictionary):
	super._on_activate({})
	delete_screen.delete_pressed.connect(_on_delete)

func _on_deactivate():
	super._on_deactivate()
	delete_screen.hide_screen()
	delete_screen.delete_pressed.disconnect(_on_delete)

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

func _update(delta: float):
	super._update(delta)

	var grid_pos = Grid.grid_mouse_pos(object)
	if grid_pos != current_pos:
		move_object(grid_pos)

	if Input.is_action_just_pressed("build_cancel"):
		_on_cancel()
		return

	if object.removable && Input.is_action_just_released("build_delete"):
		_on_delete()
		return

	if can_place && Input.is_action_just_pressed("build_place") && !UIManager.instance.is_mouse_over_ui:
		_on_place()
		return

	if object.rotatable && Input.is_action_just_pressed("build_rotate_clockwise"):
		rotate_object(current_rotation + 90)
		return

	if object.rotatable && Input.is_action_just_pressed("building_rotate_anti_clockwise"):
		rotate_object(current_rotation - 90)
		return

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
