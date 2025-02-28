class_name UIWindow
extends Control

@export var border_texture: Texture2D

@onready var ninepatch: NinePatchRect = $TileScaleContainer/NinePatchRect
@onready var player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	if border_texture != null:
		ninepatch.texture = border_texture

func _on_visibility_changed() -> void:
	if player == null:
		return

	var visible = is_visible_in_tree()
	if !visible:
		return

	player.play("UIWindow_show")
