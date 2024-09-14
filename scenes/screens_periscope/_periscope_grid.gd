class_name GridCells
extends Control

@onready var _0: TextureRect = %"0"
@onready var _1: TextureRect = %"1"
@onready var _2: TextureRect = %"2"
@onready var _3: TextureRect = %"3"
@onready var _4: TextureRect = %"4"
@onready var _5: TextureRect = %"5"

var _air_tex: CompressedTexture2D = preload("res://assets/periskop/oxygen.png")
var _enemy_tex: CompressedTexture2D = preload("res://assets/periskop/monsters/ryba.png")
var _enemy_eyes_tex: CompressedTexture2D = preload("res://assets/periskop/monsters/eyes.png")
var _finish_tex: CompressedTexture2D = preload("res://assets/periskop/win.png")
var _destr_tex: CompressedTexture2D = preload("res://assets/periskop/destruct.png")

func _update_grid(template: Array[Cell.cell_type]) -> void:
	var _array_grid: Array[TextureRect] = [_0, _1, _2, _3, _4, _5]
	for i: int in range(template.size()):
		if(template[i] == Cell.cell_type.ENEMY and i<3):
			_array_grid[i].texture = _enemy_eyes_tex
			continue
		if(template[i] == Cell.cell_type.ENEMY and i>=3):
			_array_grid[i].texture = _enemy_tex
			continue
		if(template[i] == Cell.cell_type.AIR):
			_array_grid[i].texture = _air_tex
		elif(template[i] == Cell.cell_type.DESTRUCTABLE):
			_array_grid[i].texture = _destr_tex
		elif(template[i] == Cell.cell_type.FINISH):
			_array_grid[i].texture = _finish_tex
		else:
			_array_grid[i].texture = null
	if(template[4] == Cell.cell_type.ROCK):
		for tex: TextureRect in _array_grid:
			tex.texture = null
	if(template[4] ==  Cell.cell_type.ENEMY):
		_array_grid[3].z_index = -1
		_array_grid[4].size_flags_stretch_ratio = 20.0
		_array_grid[5].z_index = -1
	else:
		_array_grid[3].z_index = 0
		_array_grid[4].size_flags_stretch_ratio = 3.09
		_array_grid[5].z_index = 0
