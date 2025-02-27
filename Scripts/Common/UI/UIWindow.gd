class_name UIWindow
extends Control

@onready var player: AnimationPlayer = $AnimationPlayer

func _on_visibility_changed() -> void:
	print("Hi")
	if player == null:
		return

	print("Play?")
	var visible = is_visible_in_tree()
	if !visible:
		return

	print("Play!")
	player.play("UIWindow_show")
