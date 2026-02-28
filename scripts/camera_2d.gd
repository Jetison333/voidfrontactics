extends Camera2D

@export var bounds: Rect2 = Rect2(0, 0, 1000, 1000)
@export var pan_speed: float = 800.0
@export var edge_margin: float = 20.0
@export var zoom_speed: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0

var is_panning: bool = false

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			is_panning = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_toward_mouse(-zoom_speed)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_toward_mouse(zoom_speed)
	
	if event is InputEventMouseMotion and is_panning:
		global_position += event.relative * 2 / zoom
		clamp_to_bounds()

func _process(delta: float) -> void:
	if is_panning:
		return
	
	var mouse = get_viewport().get_mouse_position()
	var screen = get_viewport_rect().size
	var move = Vector2.ZERO
	
	if mouse.x < edge_margin:
		move.x = -1
	elif mouse.x > screen.x - edge_margin:
		move.x = 1
	if mouse.y < edge_margin:
		move.y = -1
	elif mouse.y > screen.y - edge_margin:
		move.y = 1
	
	if move != Vector2.ZERO:
		global_position += move.normalized() * pan_speed * delta / zoom.x
		clamp_to_bounds()

func zoom_toward_mouse(amount: float) -> void:
	var mouse_world_before = get_global_mouse_position()
	var new_zoom = clampf(zoom.x + amount, min_zoom, max_zoom)
	zoom = Vector2(new_zoom, new_zoom)
	var mouse_world_after = get_global_mouse_position()
	global_position += mouse_world_before - mouse_world_after
	clamp_to_bounds()

func clamp_to_bounds() -> void:
	global_position.x = clampf(global_position.x, bounds.position.x, bounds.end.x)
	global_position.y = clampf(global_position.y, bounds.position.y, bounds.end.y)
