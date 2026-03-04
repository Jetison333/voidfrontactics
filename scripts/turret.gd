extends Node2D
class_name Turret

@export var bullet_scene: PackedScene
@export var damage: float = 10.0
@export var bullet_speed: float = 800.0
@export var fire_rate: float = 1.0  # shots per second
@export var range_: float = 300.0

var cooldown: float = 0.0
var target: Ship = null

func _physics_process(delta: float) -> void:
	cooldown -= delta
	find_target()
	if target == null:
		return
	
	# Rotate toward target
	var dir = (target.global_position - global_position).normalized()
	rotation = dir.angle()
	
	# Fire if cooled down
	if cooldown <= 0:
		fire()
		cooldown = 1.0 / fire_rate

func find_target() -> void:
	if target != null and is_instance_valid(target) and \
		target.global_position.distance_to(global_position) < range_:
		return  # keep current target if still valid and in range
	
	target = null
	var closest = INF
	for ship in get_tree().get_nodes_in_group("ships"):
		if ship.team == get_parent().team:
			continue
		var dist = ship.global_position.distance_to(global_position)
		if dist < range_ and dist < closest:
			closest = dist
			target = ship

func fire() -> void:
	var bullet = bullet_scene.instantiate()
	bullet.global_position = $BarrelTip.global_position
	bullet.init(rotation, get_parent().team, damage, bullet_speed)
	get_tree().root.add_child(bullet)  # add to root so it's not parented to the turret
