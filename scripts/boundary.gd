extends Node2D

@export var bounds: Rect2 = Rect2(0, 0, 1000, 1000)

func _draw() -> void:
	draw_rect(bounds, Color(1, 1, 1, 0.5), false, 2.0)
