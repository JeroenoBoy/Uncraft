class_name GameDefaultState
extends BaseGameState

func _init():
	_item_selector = true

func _on_activate(_state_data: Dictionary):
	super._on_activate({})
	pass

func _on_deactivate():
	super._on_deactivate()
	pass

func _update(delta: float):
	super._update(delta)

	if Input.is_action_just_pressed("build_pickup"):
		var grid_pos = Grid.grid_mouse_pos()
		var building = Grid.instance.get_building(grid_pos)
		if building != null:
			state_machine.change_state("MoveBuilding", { "building": building })
