class_name VirtualEnemy
extends Resource

enum behaviour_type{STAY ,PING_PONG, AROUND_MATRIX_1_X_1, AROUND_MATRIX_2_X_2}

enum direction_ping_pong{UP,DOWN,RIGHT,LEFT}
enum _clock_wise_movement{CLOCKWISE = -1, COUNTERCLOCKWISE = 1}

@export var ai_type: behaviour_type = behaviour_type.STAY

@export_subgroup("Move Direction Ping Pong")
@export var start_ping_pong_direction: direction_ping_pong
@export_subgroup("Move Direction Matrix")
## Enemy starts moving at (0,0) at left top corner
@export var matrix_movement: _clock_wise_movement = _clock_wise_movement.CLOCKWISE

var current_cell: Cell = Cell.new()

var _ping_ping_direction: Vector2
var _direction_vectors_for_1x1: Array[Vector2] = [Vector2.DOWN,Vector2.DOWN,Vector2.RIGHT,Vector2.RIGHT,Vector2.UP,Vector2.UP,Vector2.LEFT,Vector2.LEFT]
var _direction_vectors_for_2x2: Array[Vector2] = [Vector2.DOWN,Vector2.DOWN,Vector2.DOWN,Vector2.RIGHT,Vector2.RIGHT,Vector2.RIGHT,Vector2.UP,Vector2.UP,Vector2.UP,Vector2.LEFT,Vector2.LEFT,Vector2.LEFT]
var _last_direction_index: int = 0

func _init() -> void:
	if(direction_ping_pong.UP):
		_ping_ping_direction = Vector2.UP
	elif(direction_ping_pong.RIGHT):
		_ping_ping_direction = Vector2.RIGHT
	elif(direction_ping_pong.DOWN):
		_ping_ping_direction = Vector2.DOWN
	elif(direction_ping_pong.LEFT):
		_ping_ping_direction = Vector2.LEFT
	call_deferred("_reload_matrix_movement")

func get_direction_vector() -> Vector2:
	if(ai_type == behaviour_type.STAY):
		return Vector2(0,0)
	if(ai_type == behaviour_type.PING_PONG):
		return _ping_ping_direction
	if(ai_type == behaviour_type.AROUND_MATRIX_1_X_1):
		var ret_vec: Vector2 = _direction_vectors_for_1x1[_last_direction_index]
		print(_last_direction_index)
		_last_direction_index+=matrix_movement
		if(_is_out_of_bounds()):
			_reload_matrix_movement()
		return ret_vec
	else:
		var ret_vec: Vector2 = _direction_vectors_for_2x2[_last_direction_index]
		print(_last_direction_index)
		_last_direction_index+=matrix_movement
		if(_is_out_of_bounds()):
			_reload_matrix_movement()
		return ret_vec

func change_movement() -> void:
	if(ai_type == behaviour_type.PING_PONG):
		if(_ping_ping_direction == Vector2.UP):
			_ping_ping_direction = Vector2.DOWN
		elif(_ping_ping_direction == Vector2.RIGHT):
			_ping_ping_direction = Vector2.LEFT
		elif(_ping_ping_direction == Vector2.DOWN):
			_ping_ping_direction = Vector2.UP
		elif(_ping_ping_direction == Vector2.LEFT):
			_ping_ping_direction = Vector2.RIGHT
	if(ai_type == behaviour_type.AROUND_MATRIX_1_X_1 or ai_type == behaviour_type.AROUND_MATRIX_2_X_2):
		if(matrix_movement == _clock_wise_movement.CLOCKWISE):
			matrix_movement = _clock_wise_movement.COUNTERCLOCKWISE
		else:
			matrix_movement = _clock_wise_movement.CLOCKWISE

func _reload_matrix_movement() -> void:
	if(ai_type == behaviour_type.AROUND_MATRIX_1_X_1):
		if(matrix_movement == _clock_wise_movement.CLOCKWISE):
			_last_direction_index = _direction_vectors_for_1x1.size() -1
		else:
			_last_direction_index = 0
	elif(ai_type == behaviour_type.AROUND_MATRIX_2_X_2):
		if(matrix_movement == _clock_wise_movement.CLOCKWISE):
			_last_direction_index = _direction_vectors_for_2x2.size() -1
		else:
			_last_direction_index = 0

func _is_out_of_bounds() -> bool:
	if(ai_type == behaviour_type.AROUND_MATRIX_1_X_1):
		if(_last_direction_index == _direction_vectors_for_1x1.size() or _last_direction_index+matrix_movement < -1):
			return true
	elif(ai_type == behaviour_type.AROUND_MATRIX_2_X_2):
		if(_last_direction_index == _direction_vectors_for_2x2.size() or _last_direction_index+matrix_movement < -1):
			return true
	return false
