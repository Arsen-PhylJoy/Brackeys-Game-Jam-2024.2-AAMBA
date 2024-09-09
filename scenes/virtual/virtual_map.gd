class_name VirtualMap
extends Node
#[RRRRR] 0  1   2   3  4     [0,0][0,1][0,2][0,3][0,4]     F^- start F-FREE R-ROCK W-WIN E-ENEMY
#[RF^FRR] 5  6   7   8  9    [1,0][1,1][1,2][1,3][1,4]                 
#[REFFR] 10 11  12  13 14    [2,0][2,1][2,2][2,3][2,4] 
#[RRRFR]  15 16  17  18 19   [3,0][3,1][3,2][3,3][3,4] 
#[RRRRR]   20 21  22  23 24  [4,0][4,1][4,2][4,3][4,4] 

signal forward_visual_changed(cell: Cell)

@export var cells: Array[Cell]
var _player: VirtualPlayer = VirtualPlayer.new()

var _columns: int = 5
var _player_pos: Vector2 = Vector2(1,1)

func _ready() -> void:
	_connect_signals()
	_init_vmap()

func _connect_signals() -> void:
	(get_tree().get_nodes_in_group("move_forward_interactable")[0] as Interactable).interacted.connect(_on_player_moved)
	(get_tree().get_nodes_in_group("turn_left_interactable")[0] as Interactable).interacted.connect(_on_player_turned_left)
	(get_tree().get_nodes_in_group("turn_right_interactable")[0] as Interactable).interacted.connect(_on_player_turned_right)

func _init_vmap() -> void:
	if(cells.size() == 0):
		for i in range(_columns*_columns):
			var cell_res: Cell = Cell.new()
			cells.append(cell_res)
	print("Player pos: " + str(_player_pos) + " ON CELL: " + "Go to index: " + str((_player_pos.x + _player.player_direction.x)*_columns + (_player_pos.y + _player.player_direction.y))+ " or " + "[" +str((_player_pos.x + _player.player_direction.x)) +","+str(_player_pos.y + _player.player_direction.y)+ "]" + " type: " + str(cells[_player_pos.x*_columns + _player_pos.y].visual.load_path))

func _on_player_moved() -> void:
	print("MOVING")
	_player_pos += _player.player_direction
	print("Player pos: " + str(_player_pos) + " ON CELL: " + "Go to index: " + str((_player_pos.x + _player.player_direction.x)*_columns + (_player_pos.y + _player.player_direction.y))+ " or " + "[" +str((_player_pos.x + _player.player_direction.x)) +","+str(_player_pos.y + _player.player_direction.y)+ "]" + " type: " + str(cells[_player_pos.x*_columns + _player_pos.y].visual.load_path))
	if(cells[_player_pos.x*_columns + _player_pos.y].type == Cell.cell_type.ROCK):
		#_player_pos-=_player.player_direction
		_player.hp-=1
	if(cells[_player_pos.x*_columns + _player_pos.y].type == Cell.cell_type.ENEMY):
		#_player_pos-=_player.player_direction
		_player.hp-=2
	if(cells[_player_pos.x*_columns + _player_pos.y].type == Cell.cell_type.FINISH):
		print("WIN")
	forward_visual_changed.emit(cells[(_player_pos.x + _player.player_direction.x)*_columns + (_player_pos.y + _player.player_direction.y)])
	print("Player pos: " + str(_player_pos) + " ON CELL: " + "Go to index: " + str((_player_pos.x + _player.player_direction.x)*_columns + (_player_pos.y + _player.player_direction.y))+ " or " + "[" +str((_player_pos.x + _player.player_direction.x)) +","+str(_player_pos.y + _player.player_direction.y)+ "]" + " type: " + str(cells[_player_pos.x*_columns + _player_pos.y].visual.load_path))


#Counterclockwise
func _on_player_turned_right() -> void:
	if(_player.player_direction == Vector2(0,1)):
		_player.player_direction = Vector2(1,0)
	elif(_player.player_direction == Vector2(1,0)):
		_player.player_direction = Vector2(-1,0)
	elif(_player.player_direction == Vector2(-1,0)):
		_player.player_direction = Vector2(0,-1)
	elif(_player.player_direction == Vector2(0,-1)):
		_player.player_direction = Vector2(0,1)
	forward_visual_changed.emit(cells[(_player_pos.x + _player.player_direction.x)*_columns + (_player_pos.y + _player.player_direction.y)])
	print("Player pos: " + str(_player_pos) + "Player direction: " + str(_player.player_direction))
	print("Player pos: " + str(_player_pos) + " ON CELL: " + "Go to index: " + str((_player_pos.x + _player.player_direction.x)*_columns + (_player_pos.y + _player.player_direction.y))+ " or " + "[" +str((_player_pos.x + _player.player_direction.x)) +","+str(_player_pos.y + _player.player_direction.y)+ "]" + " type: " + str(cells[_player_pos.x*_columns + _player_pos.y].visual.load_path))

#Clockwised
func _on_player_turned_left() -> void:
	if(_player.player_direction == Vector2(0,1)):
		_player.player_direction = Vector2(0,-1)
	elif(_player.player_direction == Vector2(0,-1)):
		_player.player_direction = Vector2(-1,0)
	elif(_player.player_direction == Vector2(-1,0)):
		_player.player_direction = Vector2(1,0)
	elif(_player.player_direction == Vector2(1,0)):
		_player.player_direction = Vector2(0,1)
	forward_visual_changed.emit(cells[(_player_pos.x + _player.player_direction.x)*_columns + (_player_pos.y + _player.player_direction.y)])
	print("Player pos: " + str(_player_pos) + "Player direction: " + str(_player.player_direction))
	print("Player pos: " + str(_player_pos) + " ON CELL: " + "Go to index: " + str((_player_pos.x + _player.player_direction.x)*_columns + (_player_pos.y + _player.player_direction.y))+ " or " + "[" +str((_player_pos.x + _player.player_direction.x)) +","+str(_player_pos.y + _player.player_direction.y)+ "]" + " type: " + str(cells[_player_pos.x*_columns + _player_pos.y].visual.load_path))
