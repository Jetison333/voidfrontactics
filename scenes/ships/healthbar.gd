extends Node2D

@export var bar_width: float = 50.0
@export var bar_height: float = 6.0
@export var bar_offset: float = 40.0
@export var full_col = Color(0, 1, 0)
@export var half_col = Color(1, 0.5, 0)
@export var empty_col = Color(1, 0, 0)

var percent: float = 1

func _process(delta: float) -> void:
	global_rotation = 0.0
	queue_redraw()

func draw_health(percent_: float) -> void:
	percent = percent_
	queue_redraw()

func _draw() -> void:
	var offset = Vector2(-bar_width / 2, -bar_offset)
	
	draw_rect(Rect2(offset, Vector2(bar_width, bar_height)), Color(0.2, 0.2, 0.2))
	var fill_color = full_col if percent > 0.5 else half_col if percent > 0.25 else empty_col
	draw_rect(Rect2(offset, Vector2(bar_width * percent, bar_height)), fill_color)
