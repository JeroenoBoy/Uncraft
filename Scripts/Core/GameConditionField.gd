class_name GameConditionField
extends BaseGameValueField

@export var condition: GameCondition
@export var expected = true

func check() -> bool:
	return condition.check() == expected

func set_value():
	condition.set_value(expected)
	pass
