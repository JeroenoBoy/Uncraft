class_name GameConditionField
extends Resource

@export var condition: GameCondition
@export var expected = true

func check() -> bool:
	return condition.check() == expected
