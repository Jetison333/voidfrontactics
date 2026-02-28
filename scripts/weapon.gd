extends Node2D

@export var bullet: PackedScene

func spawn_bullet(pos: Vector2) -> Ship:
	var bullet = bullet.instantiate()
	bullet.position = pos
	bullet.team = get_parent().team
	add_child(bullet)
	return bullet
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
