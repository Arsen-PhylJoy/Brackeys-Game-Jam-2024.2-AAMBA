class_name Cell
extends Resource


enum cell_type{ROCK, ENEMY, FINISH, FREE}

@export var type: cell_type = cell_type.FREE:
	set(value):
		type = value
		_update_visual_state()

var visual: CompressedTexture2D = load("res://_utests_and_debug_instruments/assets/free.png") as CompressedTexture2D

func _init() -> void:
	_update_visual_state()

func _update_visual_state() ->void:
	if(type == cell_type.ROCK):
		visual = load("res://_utests_and_debug_instruments/assets/rock.png") as CompressedTexture2D
	elif(type == cell_type.ENEMY):
		visual = load("res://_utests_and_debug_instruments/assets/enemy.png") as CompressedTexture2D
	elif(type == cell_type.FINISH):
		visual = load("res://_utests_and_debug_instruments/assets/finish.png") as CompressedTexture2D
	elif(type == cell_type.FREE):
		visual = load("res://_utests_and_debug_instruments/assets/free.png") as CompressedTexture2D

func _get_name_of_cell() -> String:
	if(type == cell_type.FREE):
		return "FREE"
	elif(type == cell_type.ROCK):
		return "ROCK"
	elif(type == cell_type.FINISH):
		return "FINISH"
	elif(type == cell_type.ENEMY):
		return "ENEMY"
	return "ERROR CELL"
