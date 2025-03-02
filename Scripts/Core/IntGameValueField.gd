class_name IntGameValueField
extends BaseGameValueField

@export var intValue: IntGameValue
@export var value = 0

func check() -> bool:
	return intValue.get_value() == value

func set_value():
	intValue.set_value(value)
