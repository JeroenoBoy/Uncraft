class_name ObjectStoreGameValue
extends Resource

var default_value: Array[Node] = []

func get_objects() -> Array[Node]:
	return GameConditionManager.instance.get_value(self) as Array[Node]

func add_object(object: Node) -> bool:
	var obj = get_objects()
	if obj.find(object) != -1:
		return false
	obj.append(object)
	return true

func remove_object(object: Node) -> bool:
	var obj = get_objects()
	var idx = obj.find(object)
	if idx == -1:
		return false
	obj.remove_at(idx)
	return true

func clear():
	get_objects().clear()
