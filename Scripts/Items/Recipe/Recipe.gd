class_name Recipe
extends Resource

@export var craft_time = 4
@export var inputs: Array[BaseRecipeItem]
@export var output: Array[RecipeItemTransform]

func make_filters() -> Array[Filter]:
	var arr: Array[Filter] = []
	arr.append_array(inputs.map(func(it): return it.make_filter()))
	return arr
