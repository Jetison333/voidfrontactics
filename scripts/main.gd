extends Node2D

@export var bounds: Rect2 = Rect2(0, 0, 1000, 1000)

var selected_ships: Array[Ship] = []

var drag_start: Vector2 = Vector2.ZERO
var is_dragging: bool = false
const DRAG_THRESHOLD: float = 5.0  # pixels before drag starts

func clear_selected_ships() -> void:
	for ship in selected_ships:
		ship.set_selected(false)
	selected_ships.clear()

func _unhandled_input(event) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				drag_start = get_global_mouse_position()
				select_at(get_global_mouse_position())
			else:
				is_dragging = false
				queue_redraw()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			move_selected_to(get_global_mouse_position())

	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		if event.position.distance_to(drag_start) > DRAG_THRESHOLD:
			select_in_rect(Rect2(drag_start, get_global_mouse_position() - drag_start))
			is_dragging = true
		queue_redraw()
		
func select_in_rect(rect: Rect2):
	clear_selected_ships()
	for ship in get_tree().get_nodes_in_group("ships"):
		if ship.team != "player":
			continue
		if rect.abs().has_point(ship.global_position):
			selected_ships.append(ship)
			ship.set_selected(true)
			
func select_at(pos: Vector2):
	clear_selected_ships()
	var space = get_world_2d().direct_space_state
	var query = PhysicsPointQueryParameters2D.new()
	query.position = pos
	query.collision_mask = 1
	var results = space.intersect_point(query)
	for r in results:
		if r.collider.is_in_group("ships") and r.collider.team == "player":
			selected_ships.append(r.collider)
			r.collider.set_selected(true)
			
func move_selected_to(pos: Vector2):
	pos.x = clampf(pos.x, bounds.position.x, bounds.end.x)
	pos.y = clampf(pos.y, bounds.position.y, bounds.end.y)
	for ship in selected_ships:
		ship.set_destination(pos)
		
func _draw():
	if is_dragging:
		var rect = Rect2(drag_start, get_global_mouse_position() - drag_start)
		draw_rect(rect, Color(0, 1, 0, 0.1), true)    # filled
		draw_rect(rect, Color(0, 1, 0, 0.8), false)   # outline

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
