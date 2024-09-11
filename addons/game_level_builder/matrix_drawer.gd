@tool
class_name MatrixDrawer
extends Control

@onready var select_free_color: TextureButton = %SelectFREEColor
@onready var _texture_free_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/free.png")
@onready var select_rock_color: TextureButton = %SelectROCKColor
@onready var _texture_rock_tex: CompressedTexture2D = preload('res://_utests_and_debug_instruments/assets/rock.png')
@onready var select_enemy_color: TextureButton = %SelectENEMYColor
@onready var _texture_enemy_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/enemy.png")
@onready var select_finish_color: TextureButton = %SelectFINISHColor
@onready var _texture_finish_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/finish.png")
@onready var select_air_color: TextureButton = %SelectAIRColor
@onready var _texture_air_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/air.png")
@onready var select_destructable_color: TextureButton = %SelectDESTRUCTABLEColor
@onready var _texture_destructable_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/destructable.png")
@onready var select_up_player_spawn: TextureButton = %SelectUPPlayerSpawn
@onready var _texture_up_player_spawn_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/up.png")
@onready var select_down_player_spawn: TextureButton = %SelectDownPlayerSpawn
@onready var _texture_select_down_player_spawn_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/down.png")
@onready var select_right_player_spawn: TextureButton = %SelectRIGHTPlayerSpawn
@onready var _texture_select_right_player_spawn_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/right.png")
@onready var select_left_player_spawn: TextureButton = %SelectLEFTPlayerSpawn
@onready var _texture_select_left_player_spawn_tex: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/left.png")

@onready var matrix: GridContainer = %Matrix
@onready var _selected_color: TextureButton = select_free_color:
	set(value):
		_selected_color.size_flags_stretch_ratio = 1.0
		_selected_color.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
		_selected_color = value
		_selected_color.stretch_mode = TextureButton.STRETCH_SCALE
		_selected_color.size_flags_stretch_ratio = 6.0

enum color {FREE,ROCK,ENEMY,FINISH,AIR,DESTRUCTABLE,PUP,PLEFT,PRIGHT,PDOWN}

var _is_player_cell_filled: bool = false
var current_color: color = color.FREE
var _button_texture_pool: Array[TextureButton]

func _ready() -> void:
	_connect_signals()
	_selected_color.size_flags_stretch_ratio = 6.0

func _connect_signals() -> void:
	select_free_color.pressed.connect(_on_select_free_color_pressed)
	select_rock_color.pressed.connect(_on_select_rock_color_pressed)
	select_enemy_color.pressed.connect(_on_select_enemy_color_pressed)
	select_finish_color.pressed.connect(_on_select_finish_color_pressed)
	select_air_color.pressed.connect(_on_select_air_color_pressed)
	select_destructable_color.pressed.connect(_on_select_destructable_color_pressed)
	select_up_player_spawn.pressed.connect(_on_select_select_up_player_spawn_color_pressed)
	select_down_player_spawn.pressed.connect(_on_select_select_down_player_spawn_color_pressed)
	select_right_player_spawn.pressed.connect(_on_select_select_right_player_spawn_color_pressed)
	select_left_player_spawn.pressed.connect(_on_select_select_left_player_spawn_color_pressed)

func _create_matrix(dimension: int) -> void:
	_is_player_cell_filled = false
	for text_but: TextureButton in _button_texture_pool:
		text_but.free()
	_button_texture_pool.clear()
	matrix.columns = dimension
	for i: int in range(dimension*dimension):
		var tmp_text_butt: TextureButton = TextureButton.new()
		tmp_text_butt.texture_normal = _texture_rock_tex
		tmp_text_butt.ignore_texture_size = true
		tmp_text_butt.stretch_mode = TextureButton.STRETCH_SCALE
		tmp_text_butt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tmp_text_butt.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tmp_text_butt.toggle_mode = true
		matrix.add_child(tmp_text_butt)
		_button_texture_pool.append(tmp_text_butt)
	_connect_cells()

func _connect_cells() -> void:
	for tb: TextureButton in _button_texture_pool:
		tb.pressed.connect(_on_cell_pressed)

func load_vmap(vmap: VirtualMap) -> void:
	for text_but: TextureButton in _button_texture_pool:
		text_but.free()
	_button_texture_pool.clear()
	matrix.columns = (sqrt(vmap.cells.size()) as int)
	for i: int in range(vmap.cells.size()):
		var tmp_text_butt: TextureButton = TextureButton.new()
		_button_texture_pool.append(tmp_text_butt)
		if(vmap.cells[i].type == Cell.cell_type.FREE):
			_button_texture_pool[i].texture_normal = _texture_free_tex
			print("Check Load location: " + str(i%(sqrt(vmap.cells.size()) as int)) + "," +str(i/(sqrt(vmap.cells.size()) as int)))
			if(Vector2(i%(sqrt(vmap.cells.size()) as int),i/(sqrt(vmap.cells.size()) as int))== vmap._default_player_spawn):
				print("Load location: " + str(i%(sqrt(vmap.cells.size()) as int)) + "," +str(i/(sqrt(vmap.cells.size()) as int)))
				_is_player_cell_filled = true
				if(vmap._default_player_direction == Vector2(0,-1)):
					_button_texture_pool[i].texture_normal = _texture_up_player_spawn_tex
				elif(vmap._default_player_direction == Vector2(0,1)):
					_button_texture_pool[i].texture_normal = _texture_select_down_player_spawn_tex
				elif(vmap._default_player_direction == Vector2(1,0)):
					_button_texture_pool[i].texture_normal = _texture_select_right_player_spawn_tex
				elif(vmap._default_player_direction == Vector2(-1,0)):
					_button_texture_pool[i].texture_normal = _texture_select_left_player_spawn_tex
		elif(vmap.cells[i].type == Cell.cell_type.ROCK):
			_button_texture_pool[i].texture_normal = _texture_rock_tex
		elif(vmap.cells[i].type == Cell.cell_type.ENEMY):
			_button_texture_pool[i].texture_normal = _texture_enemy_tex
		elif(vmap.cells[i].type == Cell.cell_type.FINISH):
			_button_texture_pool[i].texture_normal = _texture_finish_tex
		elif(vmap.cells[i].type == Cell.cell_type.AIR):
			_button_texture_pool[i].texture_normal = _texture_air_tex
		elif(vmap.cells[i].type == Cell.cell_type.DESTRUCTABLE):
			_button_texture_pool[i].texture_normal = _texture_destructable_tex
		tmp_text_butt.ignore_texture_size = true
		tmp_text_butt.stretch_mode = TextureButton.STRETCH_SCALE
		tmp_text_butt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tmp_text_butt.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tmp_text_butt.toggle_mode = true
		matrix.add_child(tmp_text_butt)
	_connect_cells()

func _on_cell_pressed() -> void:
	print(_is_player_cell_filled)
	var _current_button: TextureButton
	for i: int in range(_button_texture_pool.size()):
		if(_button_texture_pool[i].button_pressed == true):
			_current_button = _button_texture_pool[i]
			_button_texture_pool[i].button_pressed = false
	if(_current_button.texture_normal == _texture_up_player_spawn_tex or _current_button.texture_normal == _texture_select_down_player_spawn_tex or _current_button.texture_normal == _texture_select_right_player_spawn_tex or _current_button.texture_normal == _texture_select_left_player_spawn_tex):
		_is_player_cell_filled = false
	if(current_color == color.FREE):
		_current_button.texture_normal = _texture_free_tex
	elif(current_color == color.ROCK):
		_current_button.texture_normal = _texture_rock_tex
	elif(current_color == color.ENEMY):
		_current_button.texture_normal = _texture_enemy_tex
	elif(current_color == color.FINISH):
		_current_button.texture_normal = _texture_finish_tex
	elif(current_color == color.AIR):
		_current_button.texture_normal = _texture_air_tex
	elif(current_color == color.DESTRUCTABLE):
		_current_button.texture_normal = _texture_destructable_tex
		if(_current_button.texture_normal == _texture_up_player_spawn_tex or _current_button.texture_normal == _texture_select_down_player_spawn_tex or _current_button.texture_normal == _texture_select_right_player_spawn_tex or _current_button.texture_normal == _texture_select_left_player_spawn_tex):
			_is_player_cell_filled = false
	elif(current_color == color.PUP and !_is_player_cell_filled):
		_is_player_cell_filled = true
		_current_button.texture_normal = _texture_up_player_spawn_tex
	elif(current_color == color.PDOWN and !_is_player_cell_filled):
		_is_player_cell_filled = true
		_current_button.texture_normal = _texture_select_down_player_spawn_tex
	elif(current_color == color.PRIGHT and !_is_player_cell_filled):
		_is_player_cell_filled = true
		_current_button.texture_normal = _texture_select_right_player_spawn_tex
	elif(current_color == color.PLEFT and !_is_player_cell_filled):
		_is_player_cell_filled = true
		_current_button.texture_normal = _texture_select_left_player_spawn_tex

func _on_select_free_color_pressed() -> void:
	_selected_color = select_free_color
	current_color = color.FREE

func _on_select_rock_color_pressed() -> void:
	_selected_color = select_rock_color
	current_color = color.ROCK

func _on_select_enemy_color_pressed() -> void:
	_selected_color = select_enemy_color
	current_color = color.ENEMY

func _on_select_finish_color_pressed() -> void:
	_selected_color = select_finish_color
	current_color = color.FINISH

func _on_select_air_color_pressed() -> void:
	_selected_color = select_air_color
	current_color = color.AIR

func _on_select_destructable_color_pressed() -> void:
	_selected_color = select_destructable_color
	current_color = color.DESTRUCTABLE

func _on_select_select_up_player_spawn_color_pressed() -> void:
	_selected_color = select_up_player_spawn
	current_color = color.PUP

func _on_select_select_down_player_spawn_color_pressed() -> void:
	_selected_color = select_down_player_spawn
	current_color = color.PDOWN

func _on_select_select_right_player_spawn_color_pressed() -> void:
	_selected_color = select_right_player_spawn
	current_color = color.PRIGHT

func _on_select_select_left_player_spawn_color_pressed() -> void:
	_selected_color = select_left_player_spawn
	current_color = color.PLEFT
