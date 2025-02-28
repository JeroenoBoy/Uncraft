class_name Core
extends Node2D

signal stage_started()
signal stage_completed()

@export var stages_folder = "res://Resources/GameStages"

@onready var inventory: Inventory = $Inventory

var stages: Array[CoreStage] = []
var current_stage_requirements: Array[RecipeItem] = []
var current_stage = 0

func _ready() -> void:
	inventory.item_added.connect(_on_item_added)

	var access = DirAccess.open(stages_folder)
	if !access.dir_exists(stages_folder):
		push_error("Directory '" + stages_folder + "' does not exist")
		return

	for file in access.get_files():
		var resource = ResourceLoader.load(stages_folder + "/" + file)
		if resource is not CoreStage:
			continue
		stages.append(resource)


func _on_item_added(item: Item):
	inventory.remove_specific_item(item)
	item.queue_free()

	if current_stage_requirements.size() == 0:
		return

	for requirement in current_stage_requirements:
		if requirement.item_data != item.item_data:
			continue

		if !item.has_all_parts(requirement.with_parts):
			continue
		if !item.has_none_parts(requirement.without_parts):
			continue

		requirement.count -= 1;
		if requirement.count == 0:
			current_stage_requirements.erase(requirement)

	if current_stage_requirements.size() == 0:
		stage_completed.emit()

func set_stage(stage: int):
	current_stage = stage
	current_stage_requirements = stages[stage].clone_requirements()
	stage_started.emit()
