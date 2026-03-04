extends Node2D

@export var destroyer: PackedScene
@export var fighter: PackedScene
@export var shielder: PackedScene

func spawn_ship(type: PackedScene, pos: Vector2, team: String) -> Ship:
	var ship = type.instantiate()
	ship.position = pos
	ship.team = team
	add_child(ship)
	return ship

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_ship(fighter, Vector2(100,100), "player")
	spawn_ship(fighter, Vector2(100,100), "player")
	spawn_ship(fighter, Vector2(100,600), "enemy")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
