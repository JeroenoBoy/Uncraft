class_name CoreScreen
extends UIScreen

signal complete_pressed()

@export var name_label: Label
@export var description_label: Label
@export var icon: TextureRect
@export var complete_button: Button

@export var item_display_scene: PackedScene
@export var icon_display: PackedScene

@export var container_requirements: Control
@export var container_results: Control

@onready var container_requirements_grid = container_requirements.find_child("GridContainer", false) as GridContainer
@onready var container_results_grid = container_results.find_child("GridContainer", false) as GridContainer

func _ready() -> void:
	super._ready()
	complete_button.pressed.connect(_on_complete_pressed)

func _show(screen_data: Dictionary):
	visible = true

	var items_progress = screen_data["items_progress"] as Array[RecipeItem]
	var core_stage = screen_data["core_stage"] as CoreStage
	var is_complete = screen_data["completed"] as bool

	name_label.text = core_stage.name;
	description_label.text = core_stage.description;
	icon.texture = core_stage.icon;
	complete_button.text = core_stage.button_text
	complete_button.visible = complete_button.text != ""
	set_stage_completed(is_complete)

	container_requirements.visible = items_progress.size() > 0
	container_results.visible = core_stage.results.size() > 0

	for item in items_progress:
		var instance = item_display_scene.instantiate() as DisplayItem
		container_requirements_grid.add_child(instance)
		instance.name = str(item.get_instance_id())
		instance.set_item(item.item_data, item.count, item.with_parts, item.without_parts)

	for result in core_stage.results:
		for icon in result.icons:
			var instance = icon_display.instantiate() as IconDisplay
			container_results_grid.add_child(instance)
			instance.set_icons(icon.icon, icon.second)

func _hide():
	visible = false

	for n in container_results_grid.get_children():
		n.queue_free()
	for n in container_requirements_grid.get_children():
		n.queue_free()

func update_requirement(requirement: RecipeItem):
	var child = container_requirements_grid.find_child(str(requirement.get_instance_id()), false, false)
	if child == null:
		return
	if requirement.count == 0:
		child.queue_free()
		if container_requirements_grid.get_child_count() == 0:
			container_requirements.visible = false
		return
		
	child.set_count(requirement.count)

func set_stage_completed(is_completed: bool):
	complete_button.disabled = !is_completed

func _on_complete_pressed():
	complete_pressed.emit()
