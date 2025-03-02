class_name SelectableItem
extends Button

@onready var image: TextureRect = find_child("Image", true)
@onready var name_label: Label = find_child("Label", true)
@onready var count_label: Label = find_child("Count", true)
@onready var selected_indicator = $Selected

signal on_pressed(item: SelectableItem)

var data: SelectData

func _ready() -> void:
	set_selected(false)

func set_item(select_data: SelectData):
	image.texture = select_data.icon
	image.scale = Vector2(select_data.icon_scale, select_data.icon_scale)
	name_label.text = select_data.name
	data = select_data
	set_current_count(data.initial_count)

func set_current_count(count: int):
	count_label.visible = data.max_count >= 0
	count_label.text = str(count) + "/" + str(data.max_count)
	disabled = false if data.max_count < 0 else count <= 0

	if disabled:
		modulate = Color.hex(0xffffff77)
	else:
		modulate = Color.hex(0xffffffff)

func set_selected(selected: bool):
	selected_indicator.visible = selected

func _on_pressed() -> void:
	on_pressed.emit(self)
	
class SelectData:
	var id: Variant
	var name: String
	var icon: Texture2D
	var icon_scale: float = 1.0
	
	var max_count = -1;
	var initial_count = -1;

	func _init(id: Variant, name: String, icon: Texture2D, icon_scale = 1.0):
		self.id = id
		self.name = name
		self.icon = icon
		self.icon_scale = icon_scale

	func set_limits(max: int, initial_value: int) -> SelectData:
		max_count = max
		initial_count = initial_value
		return self
