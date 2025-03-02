class_name Core
extends Node2D

signal stage_started()
signal stage_completed()
signal requirement_updated(requirement: RecipeItem)

@export var stages: Array[CoreStage] = []

@onready var inventory: Inventory = $Inventory

var current_stage_requirements: Array[RecipeItem] = []
var current_stage = 0
var is_stage_completed = false

func _ready() -> void:
	inventory.item_added.connect(_on_item_added)
	set_stage(0)

func get_stage() -> CoreStage:
	if current_stage >= stages.size():
		return null
	return stages[current_stage]

func set_stage(stage: int):
	current_stage = stage
	if current_stage >= stages.size():
		stage_started.emit()
		return

	current_stage_requirements = stages[stage].clone_requirements()
	is_stage_completed = false
	stage_started.emit()
	_try_finish_state()

func _try_finish_state():
	if is_stage_completed:
		return
	if current_stage_requirements.size() > 0:
		return
	
	is_stage_completed = true
	stage_completed.emit()
	
func _on_item_added(item: Item):
	inventory.remove_specific_item(item)
	item.queue_free()

	if is_stage_completed:
		return

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
		requirement_updated.emit(requirement)
	
	_try_finish_state()
