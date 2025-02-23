class_name Grid
extends Node2D

const CELL_SIZE = 32;
const DEFAULT_OFFSET = Vector2(CELL_SIZE / 2.0, CELL_SIZE / 2.0)
static var instance: Grid

@onready var astar: AStarGrid2D
var _grid: Dictionary = {}

func _init() -> void:
	instance = self
	astar = AStarGrid2D.new()
	astar.cell_size = Vector2i(32, 32)
	astar.region = Rect2i(Vector2i(-50,-50), Vector2i(100,100))
	astar.update()

func _ready():
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

static func world_to_grid(world_position: Vector2) -> Vector2i:
	return floor(world_position / CELL_SIZE)

static func grid_to_world(grid_position: Vector2i) -> Vector2:
	return grid_position * CELL_SIZE

static func grid_mouse_pos(adjust_for_node: GridNode = null) -> Vector2i:
	var mouse_pos = instance.get_viewport().get_camera_2d().get_global_mouse_position()
	mouse_pos += DEFAULT_OFFSET
	if adjust_for_node != null:
		var offset = ((adjust_for_node.size - Vector2i.ONE) * 0.5 + Vector2(adjust_for_node.offset)) * CELL_SIZE
		mouse_pos -= offset.rotated(adjust_for_node.global_rotation)
	return Grid.world_to_grid(mouse_pos)

static func fast_rotate(vector: Vector2i, rot: float) -> Vector2i:
	var rounded_rot = ((int(round(rot / 90)) % 4) + 4) % 4
	for i in range(rounded_rot):
		var y = vector.y
		vector.y = vector.x
		vector.x = -y
	return vector

func _exit_tree() -> void:
	instance = null

func get_buildings(grid_pos: Vector2i) -> Array[GridNode]:
	if !_grid.has(grid_pos):
		return []
	return _grid[grid_pos]

func get_building(grid_pos: Vector2i) -> GridNode:
	if !_grid.has(grid_pos):
		return null
	return _grid[grid_pos][0]
	
func set_building(node: GridNode):
	if node.is_on_grid:
		push_warning("Tried to place an already placed node")
		return

	var gridPos = world_to_grid(node.position)
	var offset = node.offset
	var rot = node.global_rotation_degrees

	for x in range(node.size.x):
		for y in range(node.size.y):
			var pos = fast_rotate(Vector2i(x + offset.x, y + offset.y), rot) + gridPos
			if !_grid.has(pos):
				astar.set_point_solid(pos, true)
				_grid[pos] = []
			_grid[pos].append(node)

	node.is_on_grid = true

func remove_building(node: GridNode):
	if !node.is_on_grid:
		push_warning("Tried to remove a node thats not placed")
		return

	var gridPos = world_to_grid(node.position)
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
	var gridPos = world_to_grid(node.position)
	var offset = node.offset
	var rot = node.global_rotation_degrees
	
	for x in range(node.size.x):
		for y in range(node.size.y):
			var pos = fast_rotate(Vector2i(x + offset.x, y + offset.y), rot) + gridPos
			if _grid.has(pos):
				return false

	return true

	
