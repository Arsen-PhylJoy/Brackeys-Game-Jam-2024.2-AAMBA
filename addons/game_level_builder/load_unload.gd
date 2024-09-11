@tool
class_name CLoadUnload
extends Control

@onready var vmap_picker: VMAPPicker = %VMAPPicker
@onready var save_level_button: Button = %SaveLevelButton

@onready var _cell_free: Cell = preload("res://godot_resources/cells/free_cell.tres")
@onready var _cell_rock: Cell = preload("res://godot_resources/cells/rock_cell.tres")
@onready var _cell_enemy: Cell = preload("res://godot_resources/cells/enemy_cell.tres")
@onready var _cell_finish: Cell = preload("res://godot_resources/cells/finish_cell.tres")

var _textures_array: Array[TextureButton]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	save_level_button.pressed.connect(_on_save_level_pressed)
	vmap_picker.resource_changed.connect(_on_resource_changes)

func _on_save_level_pressed() -> void:
	var _matrix_drawer: MatrixDrawer
	for node: Node in self.get_parent().get_parent().get_children():
		if(node is MatrixDrawer):
			_matrix_drawer = node
	_textures_array =  _matrix_drawer._button_texture_pool
	var vmap_saving: VirtualMap = VirtualMap.new()
	for i: int in range(_textures_array.size()):
		var tmp_cell: Cell = Cell.new()
		if(_textures_array[i].texture_normal == _matrix_drawer._texture_free_tex):
			tmp_cell = _cell_free
		elif(_textures_array[i].texture_normal == _matrix_drawer._texture_rock_tex):
			tmp_cell = _cell_rock
		elif(_textures_array[i].texture_normal == _matrix_drawer._texture_enemy_tex):
			tmp_cell = _cell_enemy
		elif(_textures_array[i].texture_normal == _matrix_drawer._texture_finish_tex):
			tmp_cell = _cell_finish
		vmap_saving.cells.append(tmp_cell)
	var time: String = Time.get_time_string_from_system()
	for ch: int in time.length():
		if(time[ch] == ":"):
			time[ch] = "_"
	if(!ResourceSaver.save(vmap_saving, "res://godot_resources/vmap_levels/time_" +time+"_level.tres")):
		print("res://godot_resources/vmap_levels/time_" +time+"_level.tres is SAVED")
	else:
		print("Error on saving the level")

func _on_resource_changes(res: Resource) -> void:
	var _matrix_drawer: MatrixDrawer
	for node: Node in self.get_parent().get_parent().get_children():
		if(node is MatrixDrawer):
			_matrix_drawer = node
	_matrix_drawer.load_vmap(res)
	vmap_picker.edited_resource = res
