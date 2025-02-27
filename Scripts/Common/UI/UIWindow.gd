class_name UIWindow
extends Control

@onready var player: AnimationPlayer = $AnimationPlayer

func _on_visibility_changed() -> void:
	if player == null:
		return

	var visible = is_visible_in_tree()
	if !visible:
		return

	player.play("UIWindow_show")
