class_name GameCondition
extends Resource

@export var default_value: bool

func check() -> bool:
	return GameConditionManager.instance.get_value(self)

func set_value(value: bool):
	GameConditionManager.instance.set_value(self, value)
