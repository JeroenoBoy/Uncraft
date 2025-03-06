class_name FactoryNotification
extends Node2D

@export var bobbing_frequency := 1
@export var bobbing_intensity := 8

var base_pos := Vector2.ZERO

func _ready() -> void:
	visible = true
	base_pos = get_parent().global_position - global_position
	self.set_process(true)

func _process(_delta: float) -> void:
	var parent := get_parent()
	global_rotation = 0
	global_position = parent.global_position - base_pos.rotated(parent.global_rotation) + Vector2.UP * (abs(sin(Time.get_ticks_msec() / 1000.0 * bobbing_frequency * PI)) * 2 * bobbing_intensity - bobbing_intensity * 0.5)

func _on_manufacturer_recipe_changed(recipe: Recipe) -> void:
	visible = recipe == null
	self.set_process(visible)
