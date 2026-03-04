extends Area2D
class_name Shield

@export var health = 300
@export var regen = 1

var curr_health: float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_health = health

func take_damage(amount: float) -> void:
	curr_health -= amount
	$healthbar.draw_health(curr_health / health)
	queue_redraw()
	if curr_health <= 0:
		$CollisionPolygon2D.disabled = true
		$Sprite2D.visible = false
	else:
		$CollisionPolygon2D.disabled = false
		$Sprite2D.visible = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	take_damage(-regen * delta)
