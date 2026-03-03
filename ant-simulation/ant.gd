extends Node2D

var speed = 50.0
var turn_speed = deg_to_rad(120)
var last_deposit = Vector2(500,300)
var deposit_distance =5
var sensor_angle =deg_to_rad(30)
var steer_strength = deg_to_rad(100)
var sensor_distance=40
var forward_sensor
var left_sensor
var right_sensor
var left_sensor_strength
var right_sensor_strength
var forward_sensor_strength
var minimum_sense_strength = 5
var havefood = false
var wander_distance = 0.0
var wander_threshold = 20.0
var wander_turn = 0.0
var wander_range_min = 15
var wander_range_max = 40


func _ready() -> void:
	position = Vector2(500,300)
	
func wander(delta):
	wander_distance += speed * delta
	if wander_distance >= wander_threshold:
		wander_distance = 0.0
		wander_threshold = randf_range(wander_range_min, wander_range_max)
		wander_turn = randf_range(-turn_speed, turn_speed)
	rotation += wander_turn * delta
	
	
func _process(delta: float) -> void:
		position +=Vector2(cos(rotation), sin(rotation))*speed * delta
		forward_sensor = position + Vector2(cos(rotation), sin(rotation)) * sensor_distance
		left_sensor = position + Vector2(cos(rotation-sensor_angle), sin(rotation-sensor_angle))* sensor_distance
		right_sensor = position + Vector2(cos(rotation+sensor_angle), sin(rotation+sensor_angle))* sensor_distance
		
		
		var screen = get_viewport_rect().size
		position.x = wrapf(position.x, 0, screen.x)
		position.y = wrapf(position.y, 0, screen.y)
		
		if havefood:
			if position.distance_to(last_deposit) >=deposit_distance:
				get_node("../PheromoneMap").deposit(position)
				last_deposit = position
		
		left_sensor_strength=get_node("../PheromoneMap").sample(left_sensor)
		forward_sensor_strength = get_node("../PheromoneMap").sample(forward_sensor)
		right_sensor_strength = get_node("../PheromoneMap").sample(right_sensor)
		
		if left_sensor_strength <minimum_sense_strength  and forward_sensor_strength < minimum_sense_strength and right_sensor_strength < minimum_sense_strength:
			wander(delta)
		else:
			if left_sensor_strength > forward_sensor_strength:
				rotation += -steer_strength *delta
			elif right_sensor_strength > forward_sensor_strength:
				rotation += steer_strength *delta
			elif  forward_sensor_strength > left_sensor_strength and forward_sensor_strength> right_sensor_strength:
				rotation +=0
		
		queue_redraw()
		print(left_sensor_strength, " ", forward_sensor_strength, " ", right_sensor_strength)
		
func _draw () -> void:
		var points = PackedVector2Array ([
			Vector2(10,0),
			Vector2(-6,-6),
			Vector2(-6,6),
		])
		draw_colored_polygon(points, Color.WHITE)
		draw_line(Vector2(0,0), Vector2(cos(-sensor_angle), sin(-sensor_angle)) * sensor_distance, Color.RED)
		draw_line(Vector2(0,0), Vector2(cos(sensor_angle), sin(sensor_angle)) * sensor_distance, Color.BLUE)
