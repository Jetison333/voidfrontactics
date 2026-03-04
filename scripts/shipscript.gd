extends RigidBody2D
class_name Ship

@export var team: String = "player"
@export var ShipSprite: AnimatedSprite2D
@export var turn_speed: float = 3.0
@export var max_speed: float = 400
@export var forward_thrust: float = 500.0
@export var lateral_thrust: float = 200.0
@export var health: float = 100.0
@export var patrol: Array[Vector2]

var curr_health: float
var stopping_distance: float
var destination: Vector2
var patrol_index: int

func set_selected(selected: bool) -> void:
	$SelectedSprite.visible = selected
	
func set_destination(dest: Vector2) ->void:
	destination = dest

func take_damage(amount: float) -> void:
	curr_health -= amount
	$healthbar.draw_health(curr_health / health)
	queue_redraw()
	if curr_health <= 0:
		queue_free()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("ships")
	destination = position
	patrol_index = 0
	stopping_distance = (max_speed * max_speed) / (2 * forward_thrust)
	curr_health = health
	ShipSprite.play(team)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if patrol.size() == 0:
		return
	if (position - patrol[patrol_index]).length() < 10:
		patrol_index = (patrol_index + 1) % patrol.size()
	destination = patrol[patrol_index]

func _physics_process(delta: float) -> void:
	var distance = (destination - global_position).length()
	
	var desired_velocity
	if distance > 1.0:
		desired_velocity = (destination - global_position).limit_length(max_speed)
	else:
		desired_velocity = Vector2(0,0)
	
	var breaking_speed = sqrt(2.0 * forward_thrust * distance) / 1.2
	desired_velocity = desired_velocity.limit_length(breaking_speed)
	
	var desired_accel = (desired_velocity - linear_velocity)
	var desired_thrust = desired_accel / delta
	
	# Rotate ship toward thrust direction
	var target_angle
	if true or linear_velocity.length() > max_speed / 100:
		target_angle = desired_thrust.angle()
	else:
		target_angle = rotation
	var diff = angle_difference(rotation, target_angle)
	var weight
	if diff != 0:
		weight = min(turn_speed * delta / abs(diff), 1.0)
	else:
		weight = 1.0
	rotation = lerp_angle(rotation, target_angle, weight)

	# Decompose thrust_direction into ship's local forward and lateral axes
	var ship_forward = transform.x
	var ship_lateral = transform.y
	var forward_component = desired_thrust.dot(ship_forward) * ship_forward
	var lateral_component = desired_thrust.dot(ship_lateral) * ship_lateral

	var forward_scale = forward_thrust / forward_component.length() if forward_component.length() > 0.001 else INF
	var lateral_scale = lateral_thrust / lateral_component.length() if lateral_component.length() > 0.001 else INF
	var scale = min(forward_scale, lateral_scale, 1.0)
	
	apply_force((forward_component + lateral_component) * scale)
