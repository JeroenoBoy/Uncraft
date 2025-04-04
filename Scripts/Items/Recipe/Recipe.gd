class_name Recipe
extends Resource

@export var name = ""
@export var craft_time = 4
@export var icon: Texture2D
@export var ui_icon_scale = 1.0
@export var condition: GameConditionField

@export var inputs: Array[RecipeItem]
@export var output: Array[RecipeItemTransform]

func make_filters() -> Array[Filter]:
	var arr: Array[Filter] = []
	arr.append_array(inputs.map(func(it): return it.make_filter()))
	return arr
