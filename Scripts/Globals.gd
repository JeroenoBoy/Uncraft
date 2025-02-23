class_name Globals
extends Node

var item_prefab = preload("res://Scenes/Objects/Item.tscn")

static var instance: Globals

func _init() -> void:
	instance = self
