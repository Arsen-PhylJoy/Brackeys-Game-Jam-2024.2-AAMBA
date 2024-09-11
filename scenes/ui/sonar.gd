class_name Sonar
extends AspectRatioContainer

@export_range(1,3) var default_sonar_radius: int = 3

@onready var _cells_grid_container: GridContainer = %CellsGridContainer
@onready var _player_arrow_tex_rect: TextureRect = %PlayerArrowTex

var _sonar_radius: int:
	set(value):
		if(value > 5 or value < 1 ):
			print("Too much or < 1radius")
			return
		_cells_grid_container.columns = value * 2 + 1
		_sonar_radius = value
		for tex: TextureRect in _textures_pool:
			if(tex != _player_arrow_tex_rect):
				tex.free()
				_textures_pool.clear()
		for tex: Node in _cells_grid_container.get_children():
			if(tex is TextureRect and tex != _player_arrow_tex_rect):
				tex.free()
		for i: int in range(_cells_grid_container.columns * _cells_grid_container.columns - 1):
			_textures_pool.append(TextureRect.new())
		for i: int in range(_cells_grid_container.columns * _cells_grid_container.columns - 1):
			_cells_grid_container.add_child(_textures_pool[i])
			_textures_pool[i].texture = _x_mark_tex
			_textures_pool[i].expand_mode = _player_arrow_tex_rect.expand_mode
			_textures_pool[i].stretch_mode = _player_arrow_tex_rect.stretch_mode
			_textures_pool[i].size_flags_horizontal = _player_arrow_tex_rect.size_flags_horizontal
			_textures_pool[i].size_flags_vertical = _player_arrow_tex_rect.size_flags_vertical
		# Centralize arrow texture
		_cells_grid_container.move_child(_player_arrow_tex_rect,(_cells_grid_container.columns * _cells_grid_container.columns)/2)
		_textures_pool.append(_player_arrow_tex_rect)
		_textures_pool[_textures_pool.size()-1] = _textures_pool[_textures_pool.size()/2]
		_textures_pool[_textures_pool.size()/2] = _player_arrow_tex_rect

var _textures_pool: Array[TextureRect]
var _player_arrow_topdown_tex: CompressedTexture2D = preload("res://assets/ui/player_arrow_topdown.png") as CompressedTexture2D
var _player_arrow_rightleft_tex: CompressedTexture2D = preload("res://assets/ui/player_arrow_rightleftpng.png") as CompressedTexture2D
var _free_cell_background_tex: CompressedTexture2D = preload("res://assets/ui/free_cell_background.png") as CompressedTexture2D
var _x_mark_tex: CompressedTexture2D = preload("res://assets/ui/x_mark.png") as CompressedTexture2D

func _ready() -> void:
	_connect_signals()
	_init_sonar()

func _init_sonar() -> void:
	_sonar_radius = default_sonar_radius

func _connect_signals() -> void:
	var are_connected: bool = false
	for node: Node in get_tree().current_scene.get_children():
		if(node is VirtualEnvironment):
			(node as VirtualEnvironment).player_direction_changed.connect(_on_player_direction_changed)
			(node as VirtualEnvironment).virtual_map_relative_to_player_updated.connect(_on_virtual_map_relative_to_player_updated)
			are_connected = true
	if(!are_connected):
		printerr("Virtual map is not found to connect signals")

func _on_player_direction_changed(dir: Vector2) -> void:
	if(dir == Vector2.DOWN):
		_player_arrow_tex_rect.texture = _player_arrow_topdown_tex
		_player_arrow_tex_rect.flip_v = true
	elif(dir == Vector2.RIGHT):
		_player_arrow_tex_rect.texture = _player_arrow_rightleft_tex
		_player_arrow_tex_rect.flip_h = false
	elif(dir == Vector2.UP):
		_player_arrow_tex_rect.texture = _player_arrow_topdown_tex
		_player_arrow_tex_rect.flip_v = false
	elif(dir == Vector2.LEFT):
		_player_arrow_tex_rect.texture = _player_arrow_rightleft_tex
		_player_arrow_tex_rect.flip_h = true

func _on_virtual_map_relative_to_player_updated(vmap: VirtualMap, player_pos: Vector2) -> void:
	vmap._print_debug_map()
	var player_index: int = vmap.get_index_at_position(player_pos)
	var sub_array: Array[Cell]
	var tmp_vmap: VirtualMap = VirtualMap.new()
	for i: int in range(vmap.cells.size()):
		if(player_pos.distance_to(vmap.get_position_at_index(i)) < 2 ):
			sub_array.append(vmap.get_cell_at_position(vmap.get_position_at_index(i)))
	tmp_vmap.cells = sub_array
	for i: int in range(sub_array.size()):
		if(_textures_pool[i] == _player_arrow_tex_rect):
			continue
		if(sub_array[i].type == Cell.cell_type.ROCK):
			_textures_pool[i].texture = _x_mark_tex
		else:
			_textures_pool[i].texture = _free_cell_background_tex
