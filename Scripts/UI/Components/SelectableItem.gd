class_name SelectableItem
extends Button

@onready var image: TextureRect = find_child("Image", true)
@onready var nameContainer: Label = find_child("Label", true)
@onready var selected_indicator = $Selected

signal on_pressed(item: SelectableItem)

var data: SelectData

func _ready() -> void:
	set_selected(false)

func set_item(select_data: SelectData):
	image.texture = select_data.icon
	image.scale = Vector2(select_data.icon_scale, select_data.icon_scale)
	nameContainer.text = select_data.name
	data = select_data

func set_selected(selected: bool):
	selected_indicator.visible = selected

func _on_pressed() -> void:
	on_pressed.emit(self)
	
class SelectData:
	var id: Variant
	var name: String
	var icon: Texture2D
	var icon_scale: float = 1.0

	func _init(id: Variant, name: String, icon: Texture2D, icon_scale = 1.0) -> void:
		self.id = id
		self.name = name
		self.icon = icon
		self.icon_scale = icon_scale
