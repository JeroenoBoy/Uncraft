class_name RecipeScreen
extends UIScreen

signal recipe_selected(recipe: Recipe)
signal select_button_pressed()

@export var selectable_item: PackedScene
@export var item_display: PackedScene

@export var container: Control
@export var select_button: Button

@export_group("Preview")
@export var preview_name: Label
@export var preview_craft_time: Label
@export var preview_input: Control
@export var preview_output: Control

var widgets: Array[SelectableItem] = []

func _show(screen_data: Dictionary):
	visible = true

	clear_recipes()
	for recipe in screen_data["recipes"] as Array[Recipe]:
		var widget = selectable_item.instantiate() as SelectableItem
		container.add_child(widget)
		widget.set_item(SelectableItem.SelectData.new(recipe, "", recipe.icon, recipe.ui_icon_scale))
		widget.on_pressed.connect(_on_widget_selected)
		widgets.append(widget)

	clear_preview()

func _hide():
	visible = false
	for widget in widgets:
		widget.queue_free()
	widgets.clear()

func set_preview(recipe: Recipe):
	clear_preview()
	preview_name.text = recipe.name
	preview_craft_time.text = "Craft Time: " + str(recipe.craft_time) + " seconds"
	select_button.disabled = false

	for child in container.get_children():
		child.set_selected(child.data.id == recipe)

	for input in recipe.inputs:
		var display = item_display.instantiate()
		preview_input.add_child(display)
		display.set_item(input.item_data, input.count, input.get_item_parts())

	for output in recipe.output:
		if output.transform_type == RecipeItemTransform.TransformType.RemoveItem:
			continue

		var display = item_display.instantiate()
		preview_output.add_child(display)
		display.set_item(output.item_data, output.count)

func clear_preview():
	preview_name.text = "Select a recipe"
	preview_craft_time.text = ""
	select_button.disabled = false
	for n in preview_input.get_children():
		n.queue_free()
	for n in preview_output.get_children():
		n.queue_free()

func clear_recipes():
	for n in container.get_children():
		n.queue_free()

func _on_widget_selected(widget: SelectableItem):
	recipe_selected.emit(widget.data.id)

func _on_select_button_pressed() -> void:
	select_button_pressed.emit()
