class_name MoveBuildingBackCancelAction
extends CancelableAction

var building: GridNode
var position: Vector2i
var rotation: float

func _init(building: GridNode, position: Vector2i, rotation: float) -> void:
	self.building = building
	self.position = position
	self.rotation = rotation

func cancel():
	if building.is_on_grid:
		building.pickup()

	building.position = Grid.grid_to_world(position)
	building.global_rotation_degrees = rotation
	building.place()
