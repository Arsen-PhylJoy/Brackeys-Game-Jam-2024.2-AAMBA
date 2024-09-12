class_name Sonar
extends AspectRatioContainer

@onready var _cells_grid_container: GridContainer = %CellsGridContainer

var _sonar_radius: int = 3
var _columns: int
var _textures_pool: Array[TextureRect]
var _player_arrow_topdown_tex: CompressedTexture2D = preload("res://assets/ui/player_arrow_topdown.png") as CompressedTexture2D
var _player_arrow_rightleft_tex: CompressedTexture2D = preload("res://assets/ui/player_arrow_rightleftpng.png") as CompressedTexture2D
var _free_cell_background_tex: CompressedTexture2D = preload("res://assets/ui/free_cell_background.png") as CompressedTexture2D
var _x_mark_tex: CompressedTexture2D = preload("res://assets/ui/x_mark.png") as CompressedTexture2D
var _player_arrow_tex_rect: TextureRect
var _arrow_texture_index: int

func _ready() -> void:
	for node: Node in get_tree().current_scene.get_children():
		if(node is VirtualEnvironment):
			_columns = (node as VirtualEnvironment).vmap.get_columns()
	_connect_signals()
	_init_sonar_ui()

func _connect_signals() -> void:
	var are_connected: bool = false
	for node: Node in get_tree().current_scene.get_children():
		if(node is VirtualEnvironment):
			(node as VirtualEnvironment).player_direction_changed.connect(_on_player_direction_changed)
			(node as VirtualEnvironment).virtual_map_relative_to_player_updated.connect(_on_virtual_map_relative_to_player_updated)
			are_connected = true
	if(!are_connected):
		printerr("Virtual map is not found to connect signals")

func _init_sonar_ui() -> void:
	_cells_grid_container.columns = _sonar_radius * 2 +1
	_player_arrow_tex_rect = TextureRect.new()
	_player_arrow_tex_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	_player_arrow_tex_rect.stretch_mode = TextureRect.STRETCH_SCALE
	_player_arrow_tex_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	_player_arrow_tex_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_player_arrow_tex_rect.texture = _player_arrow_rightleft_tex
	for i: int in range(_cells_grid_container.columns * _cells_grid_container.columns):
		_textures_pool.append(TextureRect.new())
		_cells_grid_container.add_child(_textures_pool[i])
		_textures_pool[i].expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		_textures_pool[i].stretch_mode = TextureRect.STRETCH_SCALE
		_textures_pool[i].size_flags_horizontal = Control.SIZE_EXPAND_FILL
		_textures_pool[i].size_flags_vertical = Control.SIZE_EXPAND_FILL
		_textures_pool[i].texture = _free_cell_background_tex

func _on_player_direction_changed(dir: Vector2) -> void:
	if(dir == Vector2.DOWN):
		_player_arrow_tex_rect.texture = _player_arrow_topdown_tex
		_player_arrow_tex_rect.flip_v = true
		_textures_pool[_arrow_texture_index].texture = _player_arrow_topdown_tex
		_textures_pool[_arrow_texture_index].flip_v = true
	elif(dir == Vector2.RIGHT):
		_player_arrow_tex_rect.texture = _player_arrow_rightleft_tex
		_player_arrow_tex_rect.flip_h = false
		_textures_pool[_arrow_texture_index].texture  = _player_arrow_rightleft_tex
		_textures_pool[_arrow_texture_index].flip_h = false
	elif(dir == Vector2.UP):
		_player_arrow_tex_rect.texture = _player_arrow_topdown_tex
		_player_arrow_tex_rect.flip_v = false
		_textures_pool[_arrow_texture_index].texture = _player_arrow_topdown_tex
		_textures_pool[_arrow_texture_index].flip_v = false
	elif(dir == Vector2.LEFT):
		_player_arrow_tex_rect.texture = _player_arrow_rightleft_tex
		_player_arrow_tex_rect.flip_h = true
		_textures_pool[_arrow_texture_index].texture = _player_arrow_rightleft_tex
		_textures_pool[_arrow_texture_index].flip_h = true

func _on_virtual_map_relative_to_player_updated(vmap: VirtualMap, player_pos: Vector2, player_dir: Vector2) -> void:
	var tmp_son_grid: sonar_grid = sonar_grid.new(vmap, player_pos, _sonar_radius)
	var sonar_cells: Array[Cell] = tmp_son_grid.get_nice_matrix(player_pos)
	_on_player_direction_changed(player_dir)
	for i: int in range((_sonar_radius * 2 +1)*(_sonar_radius * 2 +1)):
		if(sonar_cells[i].type == Cell.cell_type.FREE or sonar_cells[i].type == Cell.cell_type._SONAR_OBSCURE):
			_textures_pool[i].texture = _free_cell_background_tex
		elif(sonar_cells[i].type == Cell.cell_type.ROCK):
			_textures_pool[i].texture = _x_mark_tex
		elif(sonar_cells[i].type == Cell.cell_type._SONAR_PLAYER):
			_textures_pool[i].texture = _player_arrow_tex_rect.texture
			_arrow_texture_index = i
	_on_player_direction_changed(player_dir)


class sonar_grid:
	enum sonar_cell_type{PLAYER, OBSTACLE, FREE, SONAR_DETECTED_OBSTACLE, SONAR_DETECTED_FREE, OBSCURE}
	var sonar_map: Array[sonar_cell_type]
	var columns: int
	
	var directions: Array[Vector2] = [
	Vector2(1, 0),  # RIGHT
	Vector2(-1, 0), # LEFT
	Vector2(0, 1),  # DOWN
	Vector2(0, -1), # UP
]
	class Path:
		var path_arr: Array[int]
	var permutations: Array[Path]
	
	func _init(vmap: VirtualMap, player_pos: Vector2, _radius: int) -> void:
		columns = vmap.get_columns()
		for i: int in range(columns*columns):
				var cell_t: Cell.cell_type = vmap.cells[i].type
				if(cell_t == Cell.cell_type.FREE or cell_t == Cell.cell_type.AIR or cell_t == Cell.cell_type.FINISH or cell_t == Cell.cell_type.ENEMY):
					sonar_map.append(sonar_cell_type.FREE)
				elif(cell_t == Cell.cell_type.DESTRUCTABLE or cell_t == Cell.cell_type.ROCK):
					sonar_map.append(sonar_cell_type.OBSTACLE)
				if(vmap.get_position_at_index(i) == player_pos):
					sonar_map[i] = sonar_cell_type.PLAYER
		_generate_all_paths(_radius)
		for i: int in permutations.size():
			_cast_ray(permutations[i],player_pos)
		_clean_map()
		_debug_print_2()
		print()

	func _generate_all_paths(_radius: int) -> void:
		for i: int in range(4):
			var tmp_path: Path = Path.new()
			tmp_path.path_arr.append(i)
			permutations.append(tmp_path)
			for j: int in range(4):
				var tmp_path_2: Path  = Path.new()
				tmp_path_2.path_arr.append(i)
				tmp_path_2.path_arr.append(j)
				permutations.append(tmp_path_2)
				for k: int in range(4):
					var tmp_path_3: Path  = Path.new()
					tmp_path_3.path_arr.append(i)
					tmp_path_3.path_arr.append(j)
					tmp_path_3.path_arr.append(k)
					permutations.append(tmp_path_3)
		#for i: int in range(permutations.size()):
			#print(permutations[i].path_arr)

	func _cast_ray(in_path: Path, origin: Vector2) -> void:
		var position: Vector2 = origin
		var _last_cell: sonar_cell_type
		for direction_index: int in in_path.path_arr:
			var direction: Vector2 = directions[direction_index]
			position+=direction
			if is_out_of_bounds(position):
				break  # Stop if the position is out of bounds
			var index: int = to_index(position.x, position.y)
			var cell_type: sonar_cell_type  = sonar_map[index]
			if cell_type == sonar_cell_type.OBSTACLE or cell_type == sonar_cell_type.SONAR_DETECTED_OBSTACLE or _last_cell == sonar_cell_type.SONAR_DETECTED_OBSTACLE:
				sonar_map[index] = sonar_cell_type.SONAR_DETECTED_OBSTACLE
				break
			elif(cell_type != sonar_cell_type.SONAR_DETECTED_OBSTACLE and _last_cell != sonar_cell_type.SONAR_DETECTED_OBSTACLE):
				sonar_map[index] = sonar_cell_type.SONAR_DETECTED_FREE
			_last_cell = cell_type
		sonar_map[to_index(origin.x, origin.y)] = sonar_cell_type.PLAYER

	func _clean_map() ->void:
		for i: int in range(columns*columns):
			if(sonar_map[i] != sonar_cell_type.SONAR_DETECTED_OBSTACLE and sonar_map[i] != sonar_cell_type.SONAR_DETECTED_FREE and sonar_map[i] != sonar_cell_type.PLAYER):
				sonar_map[i] = sonar_cell_type.OBSCURE

	func to_index(x: int, y: int) -> int:
		return y * columns + x

	func is_out_of_bounds(position: Vector2) -> bool:
		return position.x < 0 or position.x >= columns or position.y < 0 or position.y >= columns

	func _get_string_sonar_cell_type(type: int) -> String:
		if(type == sonar_cell_type.PLAYER):
			return "P"
		elif(type == sonar_cell_type.OBSTACLE):
			return "O"
		elif(type == sonar_cell_type.FREE):
			return "F"
		elif(type == sonar_cell_type.SONAR_DETECTED_OBSTACLE):
			return "!"
		elif(type == sonar_cell_type.SONAR_DETECTED_FREE):
			return "W"
		return "Error_get_string_sonar_cell_type"

	func get_nice_matrix(player_pos: Vector2) -> Array[Cell]:
		var tmp_cells: Array[Cell]
		for i: int in range(49):
			var tmp_cell: Cell = Cell.new()
			tmp_cells.append(tmp_cell)
		tmp_cells[24].type = Cell.cell_type._SONAR_PLAYER
		var position_vectors: Array[Vector2]
		for row: int in range(7):
			for col: int in range(7):
				position_vectors.append(Vector2(col-3,row-3))
		for i: int in range(49):
			var tmp_sonar_type: sonar_cell_type
			var prev_position: Vector2 = player_pos + position_vectors[i]
			if is_out_of_bounds(prev_position):
				continue
			if (sonar_map[to_index(prev_position.x,prev_position.y)] == sonar_cell_type.SONAR_DETECTED_OBSTACLE):
				tmp_cells[i].type = Cell.cell_type.ROCK
			elif (sonar_map[to_index(prev_position.x,prev_position.y)] == sonar_cell_type.SONAR_DETECTED_FREE):
				tmp_cells[i].type = Cell.cell_type.FREE
			else:
				tmp_cells[i].type = Cell.cell_type._SONAR_OBSCURE
		tmp_cells[24].type = Cell.cell_type._SONAR_PLAYER
		_debug_print_3(tmp_cells)
		return tmp_cells

	func _debug_print() -> void:
		var buff: String
		for i: int in range(columns*columns):
			buff += str(_get_string_sonar_cell_type(sonar_map[i]) +",")
			if((i+1)%columns == 0):
				print(buff)
				buff = ""

	func _debug_print_2() -> void:
		var buff: String
		for i: int in range(columns*columns):
			if(sonar_map[i] == sonar_cell_type.OBSCURE):
				buff += "_,"
			else:
				buff += str(_get_string_sonar_cell_type(sonar_map[i]) +",")
			if((i+1)%columns == 0):
				print(buff)
				buff = ""

	func _debug_print_3(ar:Array[Cell]) -> void:
		var buff: String
		for i: int in range(7*7):
			if(ar[i].type == Cell.cell_type.FREE):
				buff+="W,"
			elif(ar[i].type == Cell.cell_type.ROCK):
				buff+="!,"
			elif(ar[i].type == Cell.cell_type._SONAR_PLAYER):
				buff+="P,"
			elif(ar[i].type == Cell.cell_type._SONAR_OBSCURE):
				buff+="_,"
			if((i+1)%columns == 0):
				print(buff)
				buff = ""
