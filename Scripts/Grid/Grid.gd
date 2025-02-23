class_name Grid
extends Node2D

const CELL_SIZE = 32;
static var instance: Grid

@onready var astar: AStarGrid2D = AStarGrid2D.new()
var _nodes: Dictionary = {}

func _init() -> void:
	instance = self

func _ready():
	astar.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_NEVER

static func world_to_grid(worldPosition: Vector2) -> Vector2i:
	return floor(worldPosition / CELL_SIZE)

static func grid_to_world(gridPosition: Vector2i) -> Vector2:
	return gridPosition * CELL_SIZE


func _exit_tree() -> void:
	instance = null

func get_nodes(position: Vector2i) -> Array[GridNode]:
	return _nodes[position]

func set_node(node: GridNode):
	if node.is_registered:
		push_warning("Tried to place an already placed node")
		return

	var gridPos = world_to_grid(node.position)
	gridPos += node.offset

	for x in range(node.size.x):
		for y in range(node.size.y):
			var pos = Vector2i(x + gridPos.x, y + gridPos.y)
			if !_nodes.has(pos):
				astar.set_point_solid(pos, true)
				_nodes[pos] = []
			_nodes[pos].append(node)

	node.is_registered = true

func remove_node(node: GridNode):
	if !node.is_registered:
		push_warning("Tried to remove a node thats not placed")
		return

	var gridPos = world_to_grid(node.position)
	gridPos += node.offset

	for x in range(node.size.x):
		for y in range(node.size.y):
			var pos = Vector2i(x + gridPos.x, y + gridPos.y)
			if !_nodes.has(pos):
				continue

			if _nodes[pos].size == 1:
				astar.set_point_solid(pos, false)
				_nodes[pos] = null
			else:
				_nodes[pos].erase(node)

	node.is_registered = false
	
func is_spot_occupied(node: GridNode) -> bool:
	var gridPos = world_to_grid(node.position)
	gridPos += node.offset
	
	for x in range(node.size.x):
		for y in range(node.size.y):
			var pos = Vector2i(x + gridPos.x, y + gridPos.y)
			if _nodes.has(pos):
				return false

	return true

	
