class_name GridNode
extends Node2D

@export var size = Vector2i.ONE
@export var offset = Vector2i.ZERO
@export var movable = true;
@export var rotatable = true;
@export var removable = true;

var place_on_spawn = true;

var childNodes: Array[GridNode] = []
var is_registered = false

signal on_placed()
signal on_pickup()

func _ready() -> void:
	var children = find_children("*", "GridNode")
	for child in children:
		child.place_on_spawn = false;
		on_placed.connect(child.place)
		on_pickup.connect(child.pickup)
		childNodes.append(child)

	if place_on_spawn:
		place()

func _exit_tree() -> void:
	for child in childNodes:
		on_placed.disconnect(child.place)
		on_pickup.disconnect(child.pickup)
	childNodes.clear()

func rotation() -> Vector2i:
	var rot = floor(global_rotation_degrees / 90)
	if rot == 0:
		return Vector2i.UP
	if rot == 1:
		return Vector2i.RIGHT
	if rot == 2:
		return Vector2i.DOWN
	return Vector2i.LEFT

func place():
	Grid.instance.set_node(self)
	on_placed.emit()

func pickup():
	on_pickup.emit()
