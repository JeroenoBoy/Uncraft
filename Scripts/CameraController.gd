class_name CameraController
extends Camera2D

static var instance: CameraController

@export_group("Movement")
@export var move_speed = 32

@export_group("Zoom")
@export var min_zoom = 0.5;
@export var max_zoom = 2.0;
@export var zoom_speed = 0.5;
@export var zoom_curve: Curve

var zoom_progress = 0
var can_move = false

func _init() -> void:
	instance = self
	zoom_progress = inverse_lerp(min_zoom, max_zoom,scale.x)

func _process(delta: float) -> void:
	_process_zoom()
	_process_movement(delta)

func _process_movement(delta: float):
	var vertical = Input.get_axis("camera_down", "camera_up")
	var horizontal = Input.get_axis("camera_left", "camera_right")
	var input = Vector2(horizontal, -vertical).normalized()

	if input.length() < .3:
		input = Vector2.ZERO
	
	var zoom_value = lerp(min_zoom, max_zoom, zoom_curve.sample(zoom_progress))
	position += input * move_speed * delta * zoom_value

	var vp = get_viewport_rect().size * (1/zoom.x) * .5
	position = Vector2(clamp(position.x, limit_left + vp.x, limit_right - vp.x), clamp(position.y, limit_top + vp.y, limit_bottom - vp.y))

func _process_zoom():
	var zoom_input = 0
	if Input.is_action_just_released("camera_zoom_in"):
		zoom_input = -zoom_speed
	elif Input.is_action_just_released("camera_zoom_out"):
		zoom_input = zoom_speed

	zoom_progress = clamp(zoom_progress + zoom_input * zoom_speed, 0, 1)
	var zoom_value = lerp(min_zoom, max_zoom, zoom_curve.sample(zoom_progress))
	zoom = Vector2.ONE * (1 / zoom_value)
