class_name GridNode
extends Node2D

signal tile_update()
signal function_update()

signal placed()
signal picked_up()

@export var size := Vector2i.ONE
@export var offset := Vector2i.ZERO
@export var movable := true
@export var rotatable := true
@export var removable := true
@export var replacable := false
@export var area_delete := false
@export var object_store: ObjectStoreGameValue
@export var place_on_spawn := false

var childNodes: Array[GridNode] = []
var is_on_grid = false

func _ready() -> void:
	var children = find_children("*", "GridNode")
	for child in children:
		child.place_on_spawn = false;
		placed.connect(child.place)
		picked_up.connect(child.pickup)
		childNodes.append(child)

	if place_on_spawn:
		place()

	if object_store != null:
		object_store.add_object(self)

func _exit_tree() -> void:
	for child in childNodes:
		placed.disconnect(child.place)
		picked_up.disconnect(child.pickup)
	childNodes.clear()

	if object_store != null:
		object_store.remove_object(self)

func grid_position() -> Vector2i:
	return Grid.world_to_grid(global_position)

func grid_rotation() -> Vector2i:
	var rot = (int(round(global_rotation_degrees / 90)) % 4 + 4) % 4
	match rot:
		0: return Vector2i.UP
		1: return Vector2i.RIGHT
		2: return Vector2i.DOWN
		3: return Vector2i.LEFT
		_: 
			push_error("Invalid rotation ", rot)
			return Vector2i.ZERO

func place():
	Grid.instance.set_grid_node(self)
	placed.emit()
	tile_update.emit()

func pickup():
	Grid.instance.remove_grid_node(self)
	picked_up.emit()
