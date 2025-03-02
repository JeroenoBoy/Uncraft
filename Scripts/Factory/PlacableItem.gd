class_name PlaceableItem
extends Resource

@export var name: String
@export var ui_icon_scale = 1.0
@export var sprite: Texture2D
@export var node: PackedScene

@export_group("Limits")
@export var condition: GameConditionField
@export var place_limit: IntGameValue
@export var placed_store: ObjectStoreGameValue

func can_place() -> bool:
	if condition != null && !condition.check():
		return false
	if place_limit != null && placed_store != null:
		return placed_store.get_objects().size() < place_limit.get_value()
	return true
