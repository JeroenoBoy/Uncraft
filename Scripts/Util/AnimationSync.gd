class_name AnimationSync
extends Timer

@export var frames: SpriteFrames
@export var animation = "default"
@export var group: String

var frame = 0
var frame_count = 0

func _ready() -> void:
	wait_time = 1.0 / frames.get_animation_speed(animation)
	frame_count = frames.get_frame_count(animation)

func _on_timeout():
	frame += 1
	frame = frame % frame_count
	get_tree().set_group(group, "frame", frame)
