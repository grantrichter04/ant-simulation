extends Node2D

var speed = 50.0
var turn_speed = 30.0

func _ready() -> void:
	position = Vector2(500,300)
	
	
func _process(delta: float) -> void:
		rotation += randf_range(-turn_speed, turn_speed) *delta
		position +=Vector2(cos(rotation), sin(rotation))*speed * delta
		queue_redraw()
		var screen = get_viewport_rect().size
		position.x = wrapf(position.x, 0, screen.x)
		position.y = wrapf(position.y, 0, screen.y)
func _draw () -> void:
		var points = PackedVector2Array ([
			Vector2(10,0),
			Vector2(-6,-6),
			Vector2(-6,6),
		])
		draw_colored_polygon(points, Color.WHITE)
			
