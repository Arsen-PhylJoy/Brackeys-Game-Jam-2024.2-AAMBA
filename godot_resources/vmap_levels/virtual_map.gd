class_name VirtualMap
extends Resource

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
		
