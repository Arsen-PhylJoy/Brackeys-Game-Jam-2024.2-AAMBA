extends GridContainer

var _venv: VirtualEnvironment
var _texture_air_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/air.png")
var _texture_destructable_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/destructable.png")
var _texture_enemy_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/enemy.png")
var _texture_finish_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/finish.png")
var _texture_free_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/free.png")
var _texture_rock_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/rock.png")
var _texture_playerUP_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/up.png")
var _texture_playerDOWN_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/down.png")
var _texture_playerRIGHT_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/right.png")
var _texture_playerLEFT_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/left.png")

var _player_cell: TextureRect
var _texture_pool: Array[TextureRect]

func _ready() -> void:
	_init_vmap_mapping()
	_create_map()
	_connect_signals()

func _init_vmap_mapping() -> void:
	for i: Node in get_tree().current_scene.get_children():
		if( i is VirtualEnvironment):
			_venv = i
			break
	if(_venv == null):
		print("Can't find virtual environment node")

func _create_map()-> void:
	for i: int in range(_venv.vmap.cells.size()):
		(self as GridContainer).columns = _venv.vmap.get_columns()
		var tmp_text_rect: TextureRect = TextureRect.new()
		_texture_pool.append(tmp_text_rect)
		(self as GridContainer).add_child(tmp_text_rect)
		tmp_text_rect.texture = _texture_free_tex
		tmp_text_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		tmp_text_rect.stretch_mode = TextureRect.STRETCH_SCALE
		tmp_text_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tmp_text_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL

func _connect_signals() -> void:
	_venv.virtual_map_relative_to_player_updated.connect(_on_virtual_map_relative_to_player_updated)
	_venv.player_direction_changed.connect(_on_player_direction_changed)

func _on_virtual_map_relative_to_player_updated(_in_cells: VirtualMap, player_pos: Vector2, player_dir: Vector2) -> void:
	for i: int in range(_venv.vmap.cells.size()):
		if(Vector2(i%_venv.vmap.get_columns(),i/_venv.vmap.get_columns()) == player_pos):
			_player_cell = _texture_pool[i]
			_on_player_direction_changed(_venv._player.player_direction)
		elif(_venv.vmap.cells[i].type == Cell.cell_type.FREE):
			_texture_pool[i].texture = _texture_free_tex
		elif(_venv.vmap.cells[i].type == Cell.cell_type.ROCK):
			_texture_pool[i].texture = _texture_rock_tex
		elif(_venv.vmap.cells[i].type == Cell.cell_type.ENEMY):
			_texture_pool[i].texture = _texture_enemy_tex
		elif(_venv.vmap.cells[i].type == Cell.cell_type.FINISH):
			_texture_pool[i].texture = _texture_finish_tex
		elif(_venv.vmap.cells[i].type == Cell.cell_type.AIR):
			_texture_pool[i].texture = _texture_air_tex
		elif(_venv.vmap.cells[i].type == Cell.cell_type.DESTRUCTABLE):
			_texture_pool[i].texture = _texture_destructable_tex

func _on_player_direction_changed(dir: Vector2) -> void:
	if(_venv._player.player_direction == Vector2.UP):
		_player_cell.texture = _texture_playerUP_tex
	elif(_venv._player.player_direction == Vector2.DOWN):
		_player_cell.texture = _texture_playerDOWN_tex
	elif(_venv._player.player_direction == Vector2.RIGHT):
		_player_cell.texture = _texture_playerRIGHT_tex
	elif(_venv._player.player_direction == Vector2.LEFT):
		_player_cell.texture = _texture_playerLEFT_tex
