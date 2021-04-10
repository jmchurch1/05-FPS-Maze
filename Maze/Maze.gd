extends Spatial

const N = 1
const E = 2
const S = 4
const W = 8

var cell_walls = {Vector2(0, -1): N, Vector2(1, 0): E, 
				  Vector2(0, 1): S, Vector2(-1, 0): W}

var map = []
var tiles = [
	load("res://Maze/00.tscn")
	,load("res://Maze/01.tscn")
	,load("res://Maze/02.tscn")
	,load("res://Maze/03.tscn")
	,load("res://Maze/04.tscn")
	,load("res://Maze/05.tscn")
	,load("res://Maze/06.tscn")
	,load("res://Maze/07.tscn")
	,load("res://Maze/08.tscn")
	,load("res://Maze/09.tscn")
	,load("res://Maze/10.tscn")
	,load("res://Maze/11.tscn")
	,load("res://Maze/12.tscn")
	,load("res://Maze/13.tscn")
	,load("res://Maze/14.tscn")
	,load("res://Maze/15.tscn")
]


var tile = 2  # tile size (in pixels)
var width = 40  # width of map (in tiles)
var height = 20  # height of map (in tiles)
var tile_size = Vector2.ZERO

func _ready():
	randomize()
	tile_size = Vector2(tile,tile)
	make_maze()
	
func check_neighbors(cell, unvisited):
	# returns an array of cell's unvisited neighbors
	var list = []
	for n in cell_walls.keys():
		if cell + n in unvisited:
			list.append(cell + n)
	return list
	
func make_maze():
	var unvisited = []  # array of unvisited tiles
	var stack = []
	# fill the map with solid tiles
	for x in range(width):
		map.append([])
		map[x].resize(height)
		for y in range(height):
			unvisited.append(Vector2(x, y))
			map[x][y] = N|E|S|W
	var current = Vector2(0, 0)
	unvisited.erase(current)
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			var dir = next - current
			var current_walls = map[current.x][current.y] - cell_walls[dir]
			var next_walls = map[next.x][next.y] - cell_walls[-dir]
			map[current.x][current.y] = current_walls
			map[next.x][next.y] = next_walls
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
	for x in range(width):
		for z in range(height):
			var t = tiles[map[x][z]].instance()
			t.translate(Vector3(x,0,z)*tile)
			t.name = "Tile_" + str(x) + "_" + str(z)
			add_child(t)
