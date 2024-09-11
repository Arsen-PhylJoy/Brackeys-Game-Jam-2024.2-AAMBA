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
@onready var _texture_null: CompressedTexture2D = preload("res://addons/game_level_builder/null_cell.png")
@onready var matrix: GridContainer = %Matrix
@onready var _selected_color: TextureButton = select_free_color:
	set(value):
		_selected_color.size_flags_stretch_ratio = 1.0 
		_selected_color = value
		_selected_color.size_flags_stretch_ratio = 2.5

enum color {FREE,ROCK,ENEMY,FINISH}

var current_color: color = color.FREE
var _button_texture_pool: Array[TextureButton]

func _ready() -> void:
	_connect_signals()
	_selected_color.size_flags_stretch_ratio = 2.5

func _connect_signals() -> void:
	select_free_color.pressed.connect(_on_select_free_color_pressed)
	select_rock_color.pressed.connect(_on_select_rock_color_pressed)
	select_enemy_color.pressed.connect(_on_select_enemy_color_pressed)
	select_finish_color.pressed.connect(_on_select_finish_color_pressed)

func _create_matrix(dimension: int) -> void:
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
		elif(vmap.cells[i].type == Cell.cell_type.ROCK):
			_button_texture_pool[i].texture_normal = _texture_rock_tex
		elif(vmap.cells[i].type == Cell.cell_type.ENEMY):
			_button_texture_pool[i].texture_normal = _texture_enemy_tex
		elif(vmap.cells[i].type == Cell.cell_type.FINISH):
			_button_texture_pool[i].texture_normal = _texture_finish_tex
		tmp_text_butt.ignore_texture_size = true
		tmp_text_butt.stretch_mode = TextureButton.STRETCH_SCALE
		tmp_text_butt.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		tmp_text_butt.size_flags_vertical = Control.SIZE_EXPAND_FILL
		tmp_text_butt.toggle_mode = true
		matrix.add_child(tmp_text_butt)
	_connect_cells()

func _on_cell_pressed() -> void:
	print("Pressed")
	var _current_button: TextureButton
	for tb: TextureButton in _button_texture_pool:
		if(tb.button_pressed == true):
			_current_button = tb
			tb.button_pressed = false
	if(current_color == color.FREE):
		_current_button.texture_normal = _texture_free_tex
	elif(current_color == color.ROCK):
		_current_button.texture_normal = _texture_rock_tex
	elif(current_color == color.ENEMY):
		_current_button.texture_normal = _texture_enemy_tex
	elif(current_color == color.FINISH):
		_current_button.texture_normal = _texture_finish_tex

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
