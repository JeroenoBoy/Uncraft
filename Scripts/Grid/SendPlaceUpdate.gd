class_name SendPlaceUpdate
extends Node2D

func _on_place_changed() -> void:
	var pos = Grid.world_to_grid(global_position)
	var nodes = Grid.instance.get_buildings(pos)
	for node in nodes:
		node.tile_update.emit()
