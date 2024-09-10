class_name VirtualMap
extends Resource

##Only 1-4-9-16-49 and etc sizes
@export var cells: Array[Cell]

#sqrt(cells.size()) as int

func get_cell_type_at_position(pos: Vector2) -> Cell.cell_type:
	print("Getting cell at pos and index: " + str(pos) + ": "+ str(pos.x + pos.y*sqrt(cells.size()) as int) + ", which is: " + cells[pos.x + pos.y*sqrt(cells.size()) as int]._get_name_of_cell())
	return cells[pos.x + pos.y*sqrt(cells.size()) as int].type

func get_cell_at_position(pos: Vector2) -> Cell:
	print("Getting cell at pos and index: " + str(pos) + ": "+ str(pos.x + pos.y*sqrt(cells.size()) as int) + ", which is: " + cells[pos.x + pos.y*sqrt(cells.size()) as int]._get_name_of_cell())
	return cells[pos.x + pos.y*sqrt(cells.size()) as int]

func get_index_at_position(pos: Vector2) -> int:
	return pos.x + pos.y*sqrt(cells.size()) as int



#func _print_map(cells: Array[Cell]) -> void:
	#var row: String = "["
	#for i: int in range(cells.size()):
		#if(_player_pos.x*vmap._columns + _player_pos.y == i):
			#row+="*"
		#if(vmap.get_cell_type_at_position(Vector2(_player_pos.x*vmap._columns, _player_pos.y)) == Cell.cell_type.ROCK):
			#row+="R-" + str(i) + ",[ " + str(i/(sqrt(cells.size()) as int)) +","+ str(i%(sqrt(cells.size()) as int)) +"]" + ","
		#if(vmap.get_cell_type_at_position(Vector2(_player_pos.x*vmap._columns, _player_pos.y)) == Cell.cell_type.ENEMY):
			#row+="E-" + str(i) + ",[ " + str(i/(sqrt(cells.size()) as int)) +","+ str(i%(sqrt(cells.size()) as int)) +"]" + ","
		#if(vmap.get_cell_type_at_position(Vector2(_player_pos.x*vmap._columns, _player_pos.y)) == Cell.cell_type.FINISH):
			#row+="W-" + str(i) + ",[ " + str(i/(sqrt(cells.size()) as int)) +","+ str(i%(sqrt(cells.size()) as int)) +"]" + ","
		#if(vmap.get_cell_type_at_position(Vector2(_player_pos.x*vmap._columns, _player_pos.y)) == Cell.cell_type.FREE):
			#row+="F-" + str(i) + ",[ " + str(i/(sqrt(cells.size()) as int)) +","+ str(i%(sqrt(cells.size()) as int)) +"]" + ","
		#if((i+1)%(sqrt(cells.size()) as int) == 0):
			#row +="]"
			#print(row)
			#row = "["
