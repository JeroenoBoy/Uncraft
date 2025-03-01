class_name GameCheatState
extends BaseGameState

var cheat_screen: CheatScreen

func _on_first_activate():
	super._on_first_activate()
	cheat_screen = UIManager.instance.get_screen("CheatScreen") as CheatScreen

func _on_activate(state_data: Dictionary):
	super._on_activate(state_data)

	cheat_screen.button_pressed.connect(_on_button_pressed)
	cheat_screen.show_screen({ "buttons": [
		CheatScreen.Btn.new("Unlock All", _unlock_all),
		CheatScreen.Btn.new("Finish Stage", _finish_core_stage)
	]})

func _on_deactivate():
	super._on_deactivate()
	cheat_screen.button_pressed.disconnect(_on_button_pressed)
	cheat_screen.hide_screen()

func _on_ui_cancel():
	state_machine.change_state("Default")

func _on_button_pressed(data: Variant):
	if data is not Callable:
		return
	var cb = data as Callable
	cb.call()

func _finish_core_stage():
	var cores = get_tree().root.find_children("Core", "Core", true, false)
	if cores.size() == 0:
		return
	
	var core = cores[0] as Core
	core.current_stage_requirements.clear()
	core._try_finish_state()
	
func _unlock_all():
	var folder = "res://Resources/GameConditions"
	var access = DirAccess.open(folder)
	if !access.dir_exists(folder):
		push_error("Directory '"+folder+"' does not exist")
		return

	for file in access.get_files():
		var resource = ResourceLoader.load(folder + "/" + file)
		if resource is not GameCondition:
			continue
		var condition = resource as GameCondition
		condition.set_value(true)
