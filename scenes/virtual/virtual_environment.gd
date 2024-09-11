class_name VirtualEnvironment
extends Node

signal forward_visual_changed(cell: Cell)
signal player_direction_changed(dir: Vector2)
signal virtual_map_relative_to_player_updated(cells: Array[Cell], player_pos: Vector2)

@export var vmap: VirtualMap
var _player: VirtualPlayer = VirtualPlayer.new()

var _player_pos: Vector2 = Vector2(1,1)

func _ready() -> void:
	_connect_signals()
	_init_venv()

func _connect_signals() -> void:
	(get_tree().get_nodes_in_group("move_forward_interactable")[0] as Interactable).interacted.connect(_on_player_moved)
	(get_tree().get_nodes_in_group("turn_left_interactable")[0] as Interactable).interacted.connect(_on_player_turned_left)
	(get_tree().get_nodes_in_group("turn_right_interactable")[0] as Interactable).interacted.connect(_on_player_turned_right)

func _init_venv() -> void:
	virtual_map_relative_to_player_updated.emit(vmap,_player_pos)
	player_direction_changed.emit(_player.player_direction)
	forward_visual_changed.emit(vmap.get_cell_at_position(_player_pos+_player.player_direction))
	_player_pos = vmap._default_player_spawn
	_player.player_direction = vmap._default_player_direction

func _on_player_moved(interactor: Interactor) -> void:
	_player_pos += _player.player_direction
	_player.air-=1
	if(vmap.get_cell_type_at_position(_player_pos) == Cell.cell_type.AIR):
		_player.air+=1
	if(vmap.get_cell_type_at_position(_player_pos) == Cell.cell_type.ROCK):
		_player_pos-=_player.player_direction
		_player.hp-=1
	if(vmap.get_cell_type_at_position(_player_pos) == Cell.cell_type.ENEMY):
		_player_pos-=_player.player_direction
		_player.hp-=2
	if(vmap.get_cell_type_at_position(_player_pos) == Cell.cell_type.FINISH):
		pass
	forward_visual_changed.emit(vmap.get_cell_at_position(_player_pos+_player.player_direction))
	virtual_map_relative_to_player_updated.emit(vmap,_player_pos)


#Counterclockwise
func _on_player_turned_right(interactor: Interactor) -> void:
	if(_player.player_direction == Vector2.DOWN):
		_player.player_direction = Vector2.RIGHT
	elif(_player.player_direction == Vector2.RIGHT):
		_player.player_direction = Vector2.UP
	elif(_player.player_direction == Vector2.UP):
		_player.player_direction = Vector2.LEFT
	elif(_player.player_direction == Vector2.LEFT):
		_player.player_direction = Vector2.DOWN
	forward_visual_changed.emit(vmap.get_cell_at_position(_player_pos+_player.player_direction))
	player_direction_changed.emit(_player.player_direction)

#Clockwised
func _on_player_turned_left(interactor: Interactor) -> void:
	if(_player.player_direction == Vector2.DOWN):
		_player.player_direction = Vector2.LEFT
	elif(_player.player_direction == Vector2.LEFT):
		_player.player_direction = Vector2.UP
	elif(_player.player_direction == Vector2.UP):
		_player.player_direction = Vector2.RIGHT
	elif(_player.player_direction == Vector2.RIGHT):
		_player.player_direction = Vector2.DOWN
	forward_visual_changed.emit(vmap.get_cell_at_position(_player_pos+_player.player_direction))
	player_direction_changed.emit(_player.player_direction)
