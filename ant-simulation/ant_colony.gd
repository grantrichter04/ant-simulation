extends Node2D
var colony_size = 20
var ant_scene = preload("res://ant.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in colony_size:
		var ant = ant_scene.instantiate()
		add_child(ant)
		ant.pheromone_map = get_node("../PheromoneMap")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
