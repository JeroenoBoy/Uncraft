class_name GridNode
extends Node2D

signal placed()
signal picked_up()

@export var size = Vector2i.ONE
@export var offset = Vector2i.ZERO
@export var movable = true;
@export var rotatable = true;
@export var removable = true;

var place_on_spawn = true;

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

func _exit_tree() -> void:
	for child in childNodes:
		placed.disconnect(child.place)
		picked_up.disconnect(child.pickup)
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
	Grid.instance.set_building(self)
	placed.emit()

func pickup():
	Grid.instance.remove_building(self)
	picked_up.emit()
