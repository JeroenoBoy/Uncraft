class_name IntGameValue
extends Resource

@export var default_value = 0

func get_value() -> int:
	return GameConditionManager.instance.get_value(self) as int

func set_value(value: int):
	GameConditionManager.instance.set_value(self, value)
