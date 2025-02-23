class_name BaseMoveItemState
extends BaseGameState

var object: GridNode
var current_pos: Vector2i
var current_rotation = 0.0
var can_place = false

func reset_position_to_mouse():
	current_rotation = 0
	var mouse_pos = get_viewport().get_camera_2d().get_global_mouse_position()
	current_pos = Grid.world_to_grid(mouse_pos + Vector2(Grid.CELL_SIZE / 2.0, Grid.CELL_SIZE / 2.0))

func set_object(grid_node: GridNode):
	if grid_node.is_on_grid:
		push_error("GridNode cannot be placed on a grid")
		return

	object = grid_node
	move_object(current_pos)
	rotate_object(current_rotation)
	_check_valid_position()

func move_object(position: Vector2i):
	current_pos = position
	object.position = Grid.grid_to_world(current_pos)
	_check_valid_position()

func rotate_object(rotation: float):
	rotation = floor(rotation / 90) * 90
	current_rotation = rotation
	object.global_rotation_degrees = rotation
	_check_valid_position()
	
func _update(delta: float):
	super._update(delta)

	var mouse_pos = get_viewport().get_camera_2d().get_global_mouse_position()
	var grid_pos = Grid.world_to_grid(mouse_pos + Vector2(Grid.CELL_SIZE / 2.0, Grid.CELL_SIZE / 2.0))

	if grid_pos != current_pos:
		move_object(grid_pos)

	if Input.is_action_just_pressed("build_cancel"):
		_on_cancel()
		return

	if can_place && Input.is_action_just_pressed("build_place"):
		_on_place()
		return

	if object.rotatable && Input.is_action_just_pressed("build_rotate"):
		rotate_object(current_rotation + 90)
		return

func _check_valid_position():
	can_place = Grid.instance.is_spot_occupied(object)

func _on_place():
	push_error("on_place must be overridden")
	pass

func _on_cancel():
	push_error("on_cancel must be overridden")
	pass
