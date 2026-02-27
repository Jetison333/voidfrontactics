extends Camera2D

@export var pan_speed: float = 800.0
@export var edge_margin: int = 20
@export var drag_sensitivity: float = 1.0
@export var drag_speed_multiplier: float = 2.0

@export var zoom_step: float = 0.1
@export var min_zoom: float = 0.5
@export var max_zoom: float = 2.0

var dragging := false
var last_mouse_pos := Vector2.ZERO

func _ready():
	enabled = true
	
	limit_left = -1000
	limit_right = 1000
	limit_top = -1000
	limit_bottom = 1000

func _process(delta):
	if not dragging:
		handle_edge_scroll(delta)

func handle_edge_scroll(delta):
	var movement := Vector2.ZERO
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport_rect().size
	
	if mouse_pos.x <= edge_margin:
		movement.x -= 1
	elif mouse_pos.x >= viewport_size.x - edge_margin:
		movement.x += 1
		
	if mouse_pos.y <= edge_margin:
		movement.y -= 1
	elif mouse_pos.y >= viewport_size.y - edge_margin:
		movement.y += 1
	
	if movement != Vector2.ZERO:
		position += movement.normalized() * pan_speed * delta
		apply_limits()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = event.pressed
			last_mouse_pos = event.position
		
		if event.pressed:
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom_toward_mouse(-zoom_step)
			elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom_toward_mouse(zoom_step)

	if event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		position += delta * drag_sensitivity * drag_speed_multiplier / zoom
		last_mouse_pos = event.position
		apply_limits()

func zoom_toward_mouse(step):
	var mouse_world_before = get_global_mouse_position()
	
	var new_zoom_value = clamp(zoom.x + step, min_zoom, max_zoom)
	zoom = Vector2(new_zoom_value, new_zoom_value)
	
	var mouse_world_after = get_global_mouse_position()
	position += mouse_world_before - mouse_world_after
	
	apply_limits()

func apply_limits():
	var half_screen = get_viewport_rect().size * 0.5 * zoom
	
	position.x = clamp(
		position.x,
		limit_left + half_screen.x,
		limit_right - half_screen.x
	)
	
	position.y = clamp(
		position.y,
		limit_top + half_screen.y,
		limit_bottom - half_screen.y
	)
