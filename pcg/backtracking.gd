extends TileMapLayer

# stack
var path: Array = [] 
# maze path --> used for `backtracking`

# all tiles in maze mapped to position

# the aspect ratio 
# width of maze
# height of maze

# start point
# end point

# ----- params -----
# spacing for walls
# maze width between walls

# cells starting with four walls?

# Maze generation using recursive backtracking
var maze_width: int = 10
var maze_height: int = 10
var cell_size: int = 2  # 1x1 tiles per cell

# Bit flags for walls (can be combined)
# North = 1, East = 2, South = 4, West = 8
const NORTH = 1 << 0
const EAST = 1 << 1
const SOUTH = 1 << 2
const WEST = 1 << 3

var cells: Dictionary = {}  # position -> wall_flags

func _ready():
	create_maze()


func create_maze() -> void:
	# Initialize all cells with all walls (15 = 1111 in binary)
	for x in range(maze_width):
		for y in range(maze_height):
			cells[Vector2i(x, y)] = NORTH | EAST | SOUTH | WEST
	
	# Start recursive backtracking from (0, 0)
	var current = Vector2i(0, 0)
	path.push_back(current)
	
	while not path.is_empty():
		var neighbors = get_unvisited_neighbors(current)
		
		if neighbors.size() > 0:
			# Choose random neighbor
			var next = neighbors[randi() % neighbors.size()]
			
			# Remove wall between current and next
			remove_wall_between(current, next)
			
			current = next
			path.push_back(current)
		else:
			# Backtrack
			path.pop_back()
			if not path.is_empty():
				current = path[-1]
	
	# Draw the maze to tilemap
	draw_maze_to_tilemap()

func get_unvisited_neighbors(pos: Vector2i) -> Array[Vector2i]:
	var neighbors: Array[Vector2i] = []
	
	for direction in [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]:
		var neighbor = pos + direction
		if is_valid_position(neighbor) and has_all_walls(neighbor):
			neighbors.push_back(neighbor)
	
	return neighbors

func is_valid_position(pos: Vector2i) -> bool:
	return pos.x >= 0 and pos.x < maze_width and pos.y >= 0 and pos.y < maze_height

func has_all_walls(pos: Vector2i) -> bool:
	# Check if cell has all 4 walls (unvisited)
	return cells[pos] == (NORTH | EAST | SOUTH | WEST)

func remove_wall_between(current: Vector2i, next: Vector2i) -> void:
	var diff = next - current
	
	# Remove wall from current cell
	if diff == Vector2i(0, -1):  # Moving North
		cells[current] &= ~NORTH  # Remove north wall (AND with NOT NORTH)
		cells[next] &= ~SOUTH     # Remove south wall from neighbor
	elif diff == Vector2i(1, 0):  # Moving East
		cells[current] &= ~EAST
		cells[next] &= ~WEST
	elif diff == Vector2i(0, 1):  # Moving South
		cells[current] &= ~SOUTH
		cells[next] &= ~NORTH
	elif diff == Vector2i(-1, 0):  # Moving West
		cells[current] &= ~WEST
		cells[next] &= ~EAST

func draw_maze_to_tilemap() -> void:
	# Clear existing tiles
	clear()
	
	# Draw walls based on cell data
	for cell_pos in cells:
		var walls = cells[cell_pos]
		var tile_pos = cell_pos * cell_size
		
		# Check each wall using bit operations
		if walls & NORTH:  # if (walls AND NORTH) != 0
			set_cell(tile_pos + Vector2i(1, 0), 0, Vector2i(0, 0))  # North wall
		
		if walls & EAST:
			set_cell(tile_pos + Vector2i(2, 1), 0, Vector2i(0, 0))  # East wall
		
		if walls & SOUTH:
			set_cell(tile_pos + Vector2i(1, 2), 0, Vector2i(0, 0))  # South wall
		
		if walls & WEST:
			set_cell(tile_pos + Vector2i(0, 1), 0, Vector2i(0, 0))  # West wall
		
		# Always draw corners
		set_cell(tile_pos + Vector2i(0, 0), 0, Vector2i(0, 0))  # NW corner
		set_cell(tile_pos + Vector2i(2, 0), 0, Vector2i(0, 0))  # NE corner
		set_cell(tile_pos + Vector2i(0, 2), 0, Vector2i(0, 0))  # SW corner
		set_cell(tile_pos + Vector2i(2, 2), 0, Vector2i(0, 0))  # SE corner

# Utility function to check if specific wall exists
func has_wall(pos: Vector2i, wall: int) -> bool:
	return (cells[pos] & wall) != 0

# Utility function to add wall
func add_wall(pos: Vector2i, wall: int) -> void:
	cells[pos] |= wall  # OR operation to add wall

# Utility function to remove wall  
func remove_wall(pos: Vector2i, wall: int) -> void:
	cells[pos] &= ~wall  # AND with NOT to remove wall

