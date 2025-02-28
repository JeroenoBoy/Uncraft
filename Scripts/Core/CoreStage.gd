class_name CoreStage
extends Resource

@export var name = ""
@export var icon: Texture2D
@export_multiline var description = ""
@export var button_text = "Complete"
@export var requirements: Array[RecipeItem]
@export var results: Array[CoreStageResult]

func clone_requirements() -> Array[RecipeItem]:
	var arr: Array[RecipeItem] = []
	for v in requirements:
		arr.append(v.duplicate())
	return arr

func trigger_results():
	for result in results:
		result.condition.set_value(result.value)
