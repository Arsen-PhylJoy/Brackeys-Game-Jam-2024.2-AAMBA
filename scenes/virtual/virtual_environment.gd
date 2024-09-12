class_name VirtualEnvironment
extends Node

signal forward_visual_changed(cell: Cell)
signal player_direction_changed(dir: Vector2)
signal virtual_map_relative_to_player_updated(vmap: VirtualMap, player_pos: Vector2, player_dir: Vector2)

@export var vmap: VirtualMap
@export var _player: VirtualPlayer

var _player_pos: Vector2 = Vector2(1,1)

func _ready() -> void:
	_connect_signals()
	_init_venv()

func _connect_signals() -> void:
	(get_tree().get_nodes_in_group("move_forward_interactable")[0] as Interactable).interacted.connect(_on_player_moved)
	(get_tree().get_nodes_in_group("turn_left_interactable")[0] as Interactable).interacted.connect(_on_player_turned_left)
	(get_tree().get_nodes_in_group("turn_right_interactable")[0] as Interactable).interacted.connect(_on_player_turned_right)
	#(get_tree().get_nodes_in_group("torpedo_launched")[0] as Interactable).interacted.connect(_on_torpedo_launched)
	#(get_tree().get_nodes_in_group("afterburner_used")[0] as Interactable).interacted.connect(_on_afterburner_used)

#Затычка
func _process(delta: float) -> void:
	if(Input.is_action_just_pressed("debug_action")):
		_on_torpedo_launched()
	if(Input.is_action_just_pressed("debug_action_2")):
		_on_afterburner_used()

func _init_venv() -> void:
	_player_pos = vmap._default_player_spawn
	_player.player_direction = vmap._default_player_direction
	virtual_map_relative_to_player_updated.emit(vmap,_player_pos, _player.player_direction)
	player_direction_changed.emit(_player.player_direction)
	forward_visual_changed.emit(vmap.get_cell_at_position(_player_pos+_player.player_direction))

func _on_player_moved(interactor: Interactor) -> void:
	_move_player_forward()

func _move_player_forward() -> void:
	var forward_cell_type: Cell.cell_type = vmap.get_cell_type_at_position(_player_pos + _player.player_direction)
	if(forward_cell_type == Cell.cell_type.FREE):
		_player_pos += _player.player_direction
	elif(forward_cell_type == Cell.cell_type.AIR):
		_player_pos += _player.player_direction
		_player.air += _player.air_refill_amount
	elif(forward_cell_type == Cell.cell_type.ROCK):
		_player.hp -= _player.damage_from_rocks
	elif(forward_cell_type == Cell.cell_type.ENEMY):
		_player.hp -= _player.damage_from_enemies
	elif(forward_cell_type == Cell.cell_type.DESTRUCTABLE):
		_player.hp -= _player.damage_from_destructables
	elif(forward_cell_type == Cell.cell_type.FINISH):
		_player_pos += _player.player_direction
		pass
	_player.air-=1
	forward_visual_changed.emit(vmap.get_cell_at_position(_player_pos+_player.player_direction))
	player_direction_changed.emit(_player.player_direction)
	virtual_map_relative_to_player_updated.emit(vmap, _player_pos, _player.player_direction)
	print(_player.hp)

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

func _on_torpedo_launched() -> void:
	var forward_cell: Cell = vmap.get_cell_at_position(_player_pos + _player.player_direction)
	var cell_index: int = vmap.get_index_at_position(_player_pos + _player.player_direction)
	if((forward_cell.type == Cell.cell_type.ENEMY or forward_cell.type == Cell.cell_type.DESTRUCTABLE) and _player.torpedos != 0):
		_player.torpedos -= 1
		vmap.cells[cell_index] = load("res://godot_resources/cells/free_cell.tres")
	virtual_map_relative_to_player_updated.emit(vmap, _player_pos, _player.player_direction)
	forward_visual_changed.emit(vmap.get_cell_at_position(_player_pos+_player.player_direction))

func _on_afterburner_used() -> void:
	if(_player.after_burner > 0 ):
		_player.after_burner-=1
		_move_player_forward()
		_move_player_forward()
