class_name WorldGrid
extends Node2D

static var instance: WorldGrid

const CELL_SIZE = 32;
var _nodes: Dictionary = {}

static func world_to_grid(worldPosition: Vector2) -> Vector2i:
	return floor(worldPosition / CELL_SIZE)

static func grid_to_world(gridPosition: Vector2i) -> Vector2:
	return gridPosition * CELL_SIZE

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
			if _nodes[pos] == null:
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
			if _nodes[pos] == null:
				continue

			if _nodes[pos].size == 1:
				_nodes[pos] = null
			else:
				_nodes[pos].erase(node)

	node.is_registered = false
	
func can_place_node(node: GridNode) -> bool:
	var gridPos = world_to_grid(node.position)
	gridPos += node.offset
	
	for x in range(node.size.x):
		for y in range(node.size.y):
			var pos = Vector2i(x + gridPos.x, y + gridPos.y)
			if _nodes[pos] != null:
				return false

	return true

func _ready() -> void:
	instance = self
	
