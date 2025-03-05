class_name GameDeleteState
extends BaseGameState

@onready var selection_grid: Control = $SelectionGrid

var press_started = false
var start_press_tile = Vector2i.ZERO

func _init() -> void:
	can_move_camera = true
	item_selector = true

func _ready():
	selection_grid.visible = false

func _on_first_activate():
	super._on_first_activate()
	keybinds.append(KeybindWidget.Data.new("Remove Object", "LMB"))
	keybinds.append(KeybindWidget.Data.new("Area Remove (Hold)", "LMB"))
	keybinds.append(KeybindWidget.Data.new("Cancel", "ESC"))

func _on_activate(state_data: Dictionary):
	super._on_activate(state_data)
	_reset_press()
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	UIManager.instance.show_screen("DeleteIndicator")

func _on_deactivate():
	super._on_deactivate()
	_reset_press()
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	UIManager.instance.hide_screen("DeleteIndicator")

func _on_input(event: InputEvent) -> bool:
	if super._on_input(event):
		return true
		
	if event.is_action_pressed("build_cancel"):
		state_machine.change_state("Default")
		return true

	if event.is_action_pressed("build_place"):
		start_press_tile = Grid.grid_mouse_pos()
		press_started = true
		return true

	if !press_started:
		return true

	if event.is_action_released("build_place"):
		var mouse_pos = Grid.grid_mouse_pos()
		if mouse_pos == start_press_tile:
			_try_remove_node(start_press_tile)
			_reset_press()
			return true

		var min_x = min(mouse_pos.x, start_press_tile.x)
		var min_y = min(mouse_pos.y, start_press_tile.y)
		var max_x = max(mouse_pos.x, start_press_tile.x)
		var max_y = max(mouse_pos.y, start_press_tile.y)

		for x in range(min_x, max_x + 1):
			for y in range(min_y, max_y + 1):
				var pos = Vector2i(x, y)
				_try_remove_node(pos, true)

		_reset_press()
		return true

	return false

func _update(delta: float) -> void:
	if !press_started:
		return

	var mouse_pos = Grid.grid_mouse_pos()
	selection_grid.visible = mouse_pos != start_press_tile

	var min_x = min(mouse_pos.x, start_press_tile.x)
	var min_y = min(mouse_pos.y, start_press_tile.y)
	var max_x = max(mouse_pos.x, start_press_tile.x)
	var max_y = max(mouse_pos.y, start_press_tile.y)
	var size = Vector2(max_x - min_x, max_y - min_y)
	var pos = Vector2(min_x, min_y)

	selection_grid.position = pos * Grid.CELL_SIZE - Vector2(Grid.CELL_SIZE / 2.0, Grid.CELL_SIZE / 2.0)
	selection_grid.size = (size + Vector2.ONE) * Grid.CELL_SIZE

func _reset_press():
	start_press_tile = Vector2i.ZERO
	press_started = false
	selection_grid.visible = false

func _try_remove_node(pos: Vector2i, area_delete = false):
	var grid_node = Grid.instance.get_grid_node(pos)
	if grid_node == null:
		return
	if !grid_node.removable:
		return
	if area_delete && !grid_node.area_delete:
		return
	grid_node.pickup()
	grid_node.queue_free()
