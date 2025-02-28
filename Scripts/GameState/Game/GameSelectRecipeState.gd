class_name GameSelectRecipeState
extends BaseGameState

var recipe_selector_screen: RecipeScreen
var selected_recipe: Recipe
var building: Node

func _on_first_activate():
	super._on_first_activate()
	recipe_selector_screen = UIManager.instance.get_screen("RecipeSelector") as RecipeScreen

func _on_activate(state_data: Dictionary):
	super._on_activate(state_data)

	building = state_data["building"] as Node
	var recipes = state_data["recipes"].filter(func(it): return it.condition == null || it.condition.check()) as Array[Recipe]
	selected_recipe = null
	recipe_selector_screen.show_screen({ "recipes": recipes })
	recipe_selector_screen.recipe_selected.connect(_on_recipe_selected)
	recipe_selector_screen.select_button_pressed.connect(_on_select_button_pressed)

	if building.selected_recipe != null:
		recipe_selector_screen.set_preview(building.selected_recipe)

func _on_deactivate():
	super._on_deactivate()
	recipe_selector_screen.hide_screen()
	recipe_selector_screen.recipe_selected.disconnect(_on_recipe_selected)
	recipe_selector_screen.select_button_pressed.disconnect(_on_select_button_pressed)
	recipe_selector_screen.clear_preview()

func _on_ui_cancel():
	state_machine.change_state("Default")

func _select_recipe(recipe: Recipe):
	building.set_recipe(recipe)
	state_machine.change_state("Default")

func _on_recipe_selected(recipe: Recipe):
	if selected_recipe == recipe:
		_select_recipe(recipe)
		return

	recipe_selector_screen.set_preview(recipe)
	selected_recipe = recipe

func _on_select_button_pressed():
	if selected_recipe == null:
		return
	_select_recipe(selected_recipe)
