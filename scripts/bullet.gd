extends Area2D
class_name Bullet

var speed: float = 800.0
var damage: float = 10.0
var team: String
var velocity: Vector2

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_body_entered(body) -> void:
	if body is Ship and body.team != team:
		body.take_damage(damage)
		queue_free()
		
func _on_area_entered(area) -> void:
	if area is Shield and area.get_parent().team != team:
		area.take_damage(damage)
		queue_free()

func init(dir: float, team_: String, damage_: float, speed_: float) -> void:
	self.velocity = Vector2.from_angle(dir) * speed
	self.team = team_
	self.damage = damage_
	self.speed = speed_
	rotation = dir
