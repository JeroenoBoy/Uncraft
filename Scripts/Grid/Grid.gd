class_name Grid
extends Node2D

const CELL_SIZE = 32;
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

static func world_to_grid(worldPosition: Vector2) -> Vector2i:
	return floor(worldPosition / CELL_SIZE)

static func grid_to_world(gridPosition: Vector2i) -> Vector2:
	return gridPosition * CELL_SIZE

static func grid_mouse_pos() -> Vector2i:
	var mouse_pos = instance.get_viewport().get_camera_2d().get_global_mouse_position()
	return Grid.world_to_grid(mouse_pos + Vector2(Grid.CELL_SIZE / 2.0, Grid.CELL_SIZE / 2.0))

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
	gridPos += node.offset

	for x in range(node.size.x):
		for y in range(node.size.y):
			var pos = Vector2i(x + gridPos.x, y + gridPos.y)
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
	gridPos += node.offset

	for x in range(node.size.x):
		for y in range(node.size.y):
			var pos = Vector2i(x + gridPos.x, y + gridPos.y)
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
	gridPos += node.offset
	
	for x in range(node.size.x):
		for y in range(node.size.y):
			var pos = Vector2i(x + gridPos.x, y + gridPos.y)
			if _grid.has(pos):
				return false

	return true

	
