class_name Grid
extends Node2D

const CELL_SIZE = 32;
const DEFAULT_OFFSET = Vector2(CELL_SIZE / 2.0, CELL_SIZE / 2.0)

static var instance: Grid
static var emptryArray: Array[GridNode] = []

@onready var astar: AStarGrid2D
var _grid: Dictionary = {}

func _init() -> void:
	instance = self
	astar = AStarGrid2D.new()
	astar.cell_size = Vector2i(1, 1)
	astar.region = Rect2i(Vector2i(-55,-55), Vector2i(110,110))
	astar.update()

func _ready():
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

static func world_to_grid(world_position: Vector2) -> Vector2i:
	return round(world_position / CELL_SIZE)

static func grid_to_world(grid_position: Vector2i) -> Vector2:
	return grid_position * CELL_SIZE

static func grid_mouse_pos(adjust_for_node: GridNode = null) -> Vector2i:
	var mouse_pos = instance.get_viewport().get_camera_2d().get_global_mouse_position()
	if adjust_for_node != null:
		var offset = ((adjust_for_node.size - Vector2i.ONE) * 0.5 + Vector2(adjust_for_node.offset)) * CELL_SIZE
		mouse_pos -= offset.rotated(adjust_for_node.global_rotation)
	return Grid.world_to_grid(mouse_pos)

static func grid_precise_mouse_pos() -> Vector2:
	var mouse_pos = instance.get_viewport().get_camera_2d().get_global_mouse_position()
	return mouse_pos / CELL_SIZE
	

static func fast_rotate(vector: Vector2i, rot: float) -> Vector2i:
	var rounded_rot = ((int(round(rot / 90)) % 4) + 4) % 4
	match rounded_rot:
		1:
			var y = vector.y
			vector.y = vector.x
			vector.x = -y
		2: 
			vector *= -1
		3:
			var y = vector.y
			vector.y = -vector.x
			vector.x = y
	return vector

func _exit_tree() -> void:
	instance = null

func get_grid_nodes(grid_pos: Vector2i) -> Array[GridNode]:
	if !_grid.has(grid_pos):
		return emptryArray
	return _grid[grid_pos]

func get_grid_node(grid_pos: Vector2i) -> GridNode:
	if !_grid.has(grid_pos):
		return null
	return _grid[grid_pos][0]

func get_closest_free_point(from: Vector2i) -> Vector2i:
	if !_grid.has(from):
		return from

	var offset = 1

	while true:
		if !_grid.has(from + Vector2i.UP * offset):
			return from + Vector2i.UP * offset
		if !_grid.has(from + Vector2i.LEFT * offset):
			return from + Vector2i.LEFT * offset
		if !_grid.has(from + Vector2i.DOWN * offset):
			return from + Vector2i.DOWN * offset
		if !_grid.has(from + Vector2i.RIGHT * offset):
			return from + Vector2i.RIGHT * offset
		offset += 1
	return Vector2i.ZERO

func set_grid_node(node: GridNode):
	if node.is_on_grid:
		push_warning("Tried to place an already placed node")
		return

	var gridPos = world_to_grid(node.global_position)
	var offset = node.offset
	var rot = node.global_rotation_degrees

	for x in range(node.size.x):
		for y in range(node.size.y):
			var pos = fast_rotate(Vector2i(x + offset.x, y + offset.y), rot) + gridPos
			if !_grid.has(pos):
				astar.set_point_solid(pos, true)
				_grid[pos] = [] as Array[GridNode]
			_grid[pos].append(node)

	node.is_on_grid = true

func remove_grid_node(node: GridNode):
	if !node.is_on_grid:
		push_warning("Tried to remove a node thats not placed")
		return

	var gridPos = world_to_grid(node.global_position)
	var offset = node.offset
	var rot = node.global_rotation_degrees

	for x in range(node.size.x):
		for y in range(node.size.y):
			var pos = fast_rotate(Vector2i(x + offset.x, y + offset.y), rot) + gridPos
			if !_grid.has(pos):
				continue

			if _grid[pos].size() == 1:
				astar.set_point_solid(pos, false)
				_grid.erase(pos)
			else:
				_grid[pos].erase(node)

	node.is_on_grid = false
	
func is_spot_occupied(node: GridNode) -> bool:
	var gridPos = world_to_grid(node.global_position)
	var offset = node.offset
	var rot = node.global_rotation_degrees
	
	for x in range(node.size.x):
		for y in range(node.size.y):
			var pos = fast_rotate(Vector2i(x + offset.x, y + offset.y), rot) + gridPos
			if _grid.has(pos):
				return false

	return true
