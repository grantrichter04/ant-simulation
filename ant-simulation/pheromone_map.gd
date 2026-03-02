extends Node2D

var cell_size = 10
var decay_rate = 0.2
var grid = []
var image = []
var texture=[]
var screen =[]
var new_deposit_strength = 2
var max_pheromone = 100


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen = get_viewport_rect().size
	image = Image.create(int(screen.x/cell_size), int(screen.y/cell_size), false, Image.FORMAT_RGBA8)

	for i in int(screen.y/cell_size):
		var row = []
		row.resize(int(screen.x/cell_size))
		row.fill(0)
		grid.append(row) 
		for q in int(screen.x/cell_size):
			image.set_pixel(q,i,Color(0, 0.8, 0, 0))
		
	texture =ImageTexture.create_from_image(image)

func _draw () -> void:
	draw_texture_rect(texture,Rect2(0,0,screen.x,screen.y),false)

func deposit (position):
	var cell_x = int(position.x / cell_size)
	var cell_y = int(position.y / cell_size)
	cell_x = clamp(cell_x, 0, int(screen.x/cell_size)-1)
	cell_y = clamp(cell_y, 0, int(screen.y/cell_size)-1)
	grid[cell_y][cell_x]+=new_deposit_strength
	grid[cell_y][cell_x]=clamp(grid[cell_y][cell_x],0,100)
	image.set_pixel(cell_x,cell_y,Color(0, 0.8, 0, grid[cell_y][cell_x] / max_pheromone))
	texture.update(image)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()
	for i in int(screen.y/cell_size):
		for q in int(screen.x/cell_size):
			grid[i][q]*=1.0 - (decay_rate * delta)
			image.set_pixel(q,i,Color(0, 0.8, 0, grid[i][q]/max_pheromone))
	texture.update(image)
			
