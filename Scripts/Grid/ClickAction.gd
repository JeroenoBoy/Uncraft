class_name ClickAction
extends Node

enum ClickType {
	SelectRecipe,
	CoreClicked
}

@export var click_type: ClickType
@export var target: Node2D

func execute(state_machine: GameStateMachine):
	match click_type:
		ClickType.SelectRecipe:
			if !target.has_method("set_recipe"):
				push_error("Target does not have method 'set_recipe'")
				return

			if !"recipes" in target:
				push_error("Target does not have variable 'recipes'")
				return

			if !"selected_recipe" in target:
				push_error("Target does not have variable 'selected_recipe'")
				return
				

			state_machine.change_state("SelectRecipe", {
				"building": target,
				"recipes": target.recipes
			})
		
		ClickType.CoreClicked:
			if !target is Core:
				push_error("Target must be of type Core")
				return

			state_machine.change_state("CoreInfo", {
				"core": target
			})

		_:
			push_error("Click type ", click_type, " is not implemented")
