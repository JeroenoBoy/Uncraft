class_name IconDisplay
extends Control

@onready var primary: TextureRect = $Icon
@onready var secondary_container: Control = $SubIcon
@onready var secondary: TextureRect = $SubIcon/Icon

func set_icons(primary_texture: Texture2D, secondary_texture: Texture2D = null):
	primary.texture = primary_texture
	secondary_container.visible = secondary_texture != null
	if secondary_texture == null:
		return

	secondary.texture = secondary_texture
