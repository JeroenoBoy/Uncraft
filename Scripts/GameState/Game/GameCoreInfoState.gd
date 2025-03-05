class_name GameCoreInfoState
extends BaseGameState

var core_screen: CoreScreen
var core: Core

func _on_first_activate():
	super._on_first_activate()
	core_screen = UIManager.instance.get_screen("CoreScreen") as CoreScreen
	keybinds.append(KeybindWidget.Data.new("Cancel", "ESC"))

func _on_activate(state_data: Dictionary):
	super._on_activate(state_data)
	core = state_data["core"]
	core_screen.show_screen({
		"items_progress": core.current_stage_requirements,
		"core_stage": core.get_stage(),
		"completed": core.is_stage_completed
	})
	core_screen.complete_pressed.connect(_on_complete_pressed)
	core.requirement_updated.connect(_on_requirement_updated)
	core.stage_completed.connect(_on_stage_completed)

func _on_deactivate():
	super._on_deactivate()
	core_screen.hide_screen()
	core_screen.complete_pressed.disconnect(_on_complete_pressed)
	core.requirement_updated.disconnect(_on_requirement_updated)
	core.stage_completed.disconnect(_on_stage_completed)
	core = null

func _on_ui_cancel():
	state_machine.change_state("Default")

func _on_complete_pressed():
	core.get_stage().trigger_results()
	core.set_stage(core.current_stage+1)
	state_machine.change_state("CoreInfo", { "core": core })

func _on_requirement_updated(requirement: RecipeItem):
	core_screen.update_requirement(requirement)

func _on_stage_completed():
	core_screen.set_stage_completed(true)
