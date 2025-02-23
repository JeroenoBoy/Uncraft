class_name GameDefaultState
extends BaseGameState

var item_selector_screen: ItemSelectorScreen

func _init():
	_item_selector = true

func _on_activate(_state_data: Dictionary):
	super._on_activate({})
	pass

func _on_deactivate():
	super._on_deactivate()
	pass
	
