class_name Manufacturer
extends Node2D

@export var recipes: Array[Recipe] = []
@export var outputs: Array[MachineOutput] = []

@onready var inventory: Inventory = $Inventory

var selected_recipe: Recipe

func _ready() -> void:
	select_recipe(recipes[0])

func select_recipe(recipe: Recipe):
	pass
