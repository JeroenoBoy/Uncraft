class_name ItemData
extends Resource

@export var name = ""
@export var stack_size = 10
@export var sprite: Texture2D
@export var icon: Texture2D

func get_icon() -> Texture2D:
	return sprite if icon == null else icon
