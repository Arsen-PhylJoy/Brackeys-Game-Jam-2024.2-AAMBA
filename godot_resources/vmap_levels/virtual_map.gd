class_name VirtualMap
extends Resource

signal visual_changed(in_cell: Cell, template: Array[Cell.cell_type])

##Only 1-4-9-16-49 and etc sizes
@export var cells: Array[Cell]
@export var _default_player_direction: Vector2 = Vector2(0,1)
@export var _default_player_spawn: Vector2 = Vector2(1,1)

func get_cell_type_at_position(pos: Vector2) -> Cell.cell_type:
	return cells[pos.x + pos.y*get_columns()].type

func get_cell_at_position(pos: Vector2) -> Cell:
	return cells[pos.x + pos.y*get_columns()]

func get_index_at_position(pos: Vector2) -> int:
	return pos.x + pos.y*get_columns()

func get_position_at_index(index: int) -> Vector2:
	return Vector2(index%get_columns(), index/get_columns())

func get_columns() -> int:
	return (sqrt(cells.size()) as int)

func calculate_cell_visual(in_cells: Array[Cell], pos: Vector2, look_direction: Vector2) -> void:
	var _check_template: Array[Cell.cell_type] = [Cell.cell_type.ROCK,Cell.cell_type.ROCK,Cell.cell_type.ROCK,Cell.cell_type.ROCK,Cell.cell_type.ROCK,Cell.cell_type.ROCK]
	var _position_vectors_up: Array[Vector2] = [
		Vector2(-1,-2),
		Vector2(0,-2),
		Vector2(1,-2),
		Vector2(-1,-1),
		Vector2(0,-1),
		Vector2(1,-1)
	]
	var _position_vectors_right: Array[Vector2] = [
		Vector2(2,-1),
		Vector2(2,0),
		Vector2(2,1),
		Vector2(1,-1),
		Vector2(1,0),
		Vector2(1,1)
	]
	var _position_vectors_left: Array[Vector2] = [
		Vector2(-2,1),
		Vector2(-2,0),
		Vector2(-2,-1),
		Vector2(-1,1),
		Vector2(-1,0),
		Vector2(-1,-1)
	]
	var _position_vectors_down: Array[Vector2] = [
		Vector2(1,2),
		Vector2(0,2),
		Vector2(-1,2),
		Vector2(1,1),
		Vector2(0,1),
		Vector2(-1,1)
	]
	for i: int in range(6):
		var _current_cell_pos: Vector2
		if(look_direction == Vector2.UP):
			_current_cell_pos = get_position_at_index(get_index_at_position(pos + _position_vectors_up[i]))
		elif(look_direction == Vector2.RIGHT):
			_current_cell_pos = get_position_at_index(get_index_at_position(pos + _position_vectors_right[i]))
		elif(look_direction == Vector2.LEFT):
			_current_cell_pos = get_position_at_index(get_index_at_position(pos + _position_vectors_left[i]))
		elif(look_direction == Vector2.DOWN):
			_current_cell_pos = get_position_at_index(get_index_at_position(pos + _position_vectors_down[i]))
		if(is_out_of_bounds(_current_cell_pos)):
			continue
		if(get_cell_type_at_position(_current_cell_pos) == Cell.cell_type.FREE):
			_check_template[i] = Cell.cell_type.FREE
		elif(get_cell_type_at_position(_current_cell_pos) == Cell.cell_type.FINISH):
			_check_template[i] = Cell.cell_type.FINISH
		elif(get_cell_type_at_position(_current_cell_pos) == Cell.cell_type.ROCK):
			_check_template[i] = Cell.cell_type.ROCK
		elif(get_cell_type_at_position(_current_cell_pos) == Cell.cell_type.AIR):
			_check_template[i] = Cell.cell_type.AIR
		elif(get_cell_type_at_position(_current_cell_pos) == Cell.cell_type.ROCK):
			_check_template[i] = Cell.cell_type.ROCK
		elif(get_cell_type_at_position(_current_cell_pos) == Cell.cell_type.DESTRUCTABLE):
			_check_template[i] = Cell.cell_type.DESTRUCTABLE
		elif(get_cell_type_at_position(_current_cell_pos) == Cell.cell_type.ENEMY):
			_check_template[i] = Cell.cell_type.ENEMY
	cells[get_index_at_position(pos)].update_visual_state(_check_template)
	visual_changed.emit(cells[get_index_at_position(pos)], _check_template)
	print(_check_template)

func is_out_of_bounds(position: Vector2) -> bool:
	return position.x < 0 or position.x >= get_columns() or position.y < 0 or position.y >= get_columns()

func get_position_of_nearest_finish(_player_pos: Vector2) -> Vector2:
	var _closest_dist: float = 100000000.0
	var _return_pos: Vector2 = Vector2(0,0)
	for i: int in range(cells.size()):
		if(cells[i].type == Cell.cell_type.FINISH and _player_pos.distance_to(get_position_at_index(i)) < _closest_dist):
			_closest_dist = _player_pos.distance_to(get_position_at_index(i))
			_return_pos = get_position_at_index(i)
	return _return_pos

func _print_debug_map() -> void:
	var row: String = "["
	for i: int in range(cells.size()):
		if(get_cell_type_at_position(get_position_at_index(i)) == Cell.cell_type.ROCK):
			row+="R-" + str(i) + ",[ " + str(i/(sqrt(cells.size()) as int)) +","+ str(i%(sqrt(cells.size()) as int)) +"]" + ","
		if(get_cell_type_at_position(get_position_at_index(i)) == Cell.cell_type.ENEMY):
			row+="E-" + str(i) + ",[ " + str(i/(sqrt(cells.size()) as int)) +","+ str(i%(sqrt(cells.size()) as int)) +"]" + ","
		if(get_cell_type_at_position(get_position_at_index(i)) == Cell.cell_type.FINISH):
			row+="W-" + str(i) + ",[ " + str(i/(sqrt(cells.size()) as int)) +","+ str(i%(sqrt(cells.size()) as int)) +"]" + ","
		if(get_cell_type_at_position(get_position_at_index(i)) == Cell.cell_type.FREE):
			row+="F-" + str(i) + ",[ " + str(i/(sqrt(cells.size()) as int)) +","+ str(i%(sqrt(cells.size()) as int)) +"]" + ","
		if((i+1)%(sqrt(cells.size()) as int) == 0):
			row +="]"
			print(row)
			row = "["

func _print_enemies_debug() -> void:
	for i: int in range(cells.size()):
		if(cells[i].type == Cell.cell_type.ENEMY):
			print(get_position_at_index(i))

func _print_all_combinations() -> void:
	var symbols: Array[String] = [String("-R-"),String("-F-")]
	var first_row: Array[String] = ["","",""]
	var second_row: Array[String] = ["","",""]
	var kjk: int= 0
	for i: String in symbols:
		first_row[0] = i
		for j: String in symbols:
			first_row[1] = j
			for q: String in symbols:
				first_row[2] = q
				for w: String in symbols:
					second_row[0] = w
					for n: String in symbols:
						second_row[1] = n
						for t: String in symbols:
							second_row[2] = t
							if(second_row[1] == "-R-"):
								continue
							print(first_row)
							print(second_row)
							print(kjk)
							kjk+=1
							print()
