class_name DestroyObjectCancelAction
extends CancelableAction

var object: Node

func _init(node: Node) -> void:
	object = node

func cancel():
	object.queue_free()
