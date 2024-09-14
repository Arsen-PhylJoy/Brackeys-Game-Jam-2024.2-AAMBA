class_name Cell
extends Resource


enum cell_type{ROCK, ENEMY, FINISH, FREE, AIR, DESTRUCTABLE, _SONAR_OBSCURE,_SONAR_PLAYER}

@export var type: cell_type = cell_type.FREE

var visual: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/free.png") as CompressedTexture2D
var geo_visual: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/free.png") as CompressedTexture2D
var monster_visual: CompressedTexture2D = preload("res://_utests_and_debug_instruments/assets/free.png") as CompressedTexture2D

var has_monster_visual: bool = false
var enemy_ai_handler: VirtualEnemy

#[0,0],[0,1],[0,2]
#[1,0],[1,1],[1,2] : PATHS[0] == GEOMETRY, PATHS[1] == REALISTIC
var _pattern_to_visual: Dictionary = {
	[cell_type.ROCK,cell_type.ROCK,cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/4.png"),
		preload("res://assets/periskop/4.jpg")
	],
	[cell_type.ROCK,cell_type.ROCK,cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/11.png"),
		preload("res://assets/periskop/11.jpg")
	],
	[cell_type.ROCK,cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/11_5.png"),
		preload("res://assets/periskop/11_5.jpg")
	],
	[cell_type.ROCK,cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/4.png"),
		preload("res://assets/periskop/RRRFFF.jpg")
	],
	[cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.ROCK,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/4.png"),
		preload("res://assets/periskop/4.jpg")
	],
	[cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/11_5.png"),
		preload("res://assets/periskop/11_5.jpg")
	],
	[cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/FRR-FFF_5.png"),
		preload("res://assets/periskop/FRR-FFF_5.jpg")
	],
	[cell_type.ROCK,cell_type.FREE,cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/3.png"),
		preload("res://assets/periskop/3.jpg")
	],
	[cell_type.ROCK,cell_type.FREE,cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/6_5.png"),
		preload("res://assets/periskop/6_5.jpg")
	],
	[cell_type.ROCK,cell_type.FREE,cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/6.png"),
		preload("res://assets/periskop/6.jpg")
	],
	[cell_type.ROCK,cell_type.FREE,cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/5.png"),
		preload("res://assets/periskop/5.jpg")
	],
	[cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.ROCK,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/20.png"),
		preload("res://assets/periskop/20.jpg")
	],
	[cell_type.FREE,cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.ROCK,cell_type.ROCK]: [
		preload("res://assets/periskop/10.png"),
		preload("res://assets/periskop/10.jpg")
	],
	[cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/8.png"),
		preload("res://assets/periskop/8.jpg")
	],
	[cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/RFF-FFF_5.png"),
		preload("res://assets/periskop/RFF-FFF_5.jpg")
	],
	[cell_type.FREE,cell_type.ROCK,cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/4.png"),
		preload("res://assets/periskop/4.jpg")
	],
	[cell_type.FREE,cell_type.ROCK,cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/11.png"),
		preload("res://assets/periskop/11.jpg")
	],
	[cell_type.FREE,cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/FRR-FFR.png"),
		preload("res://assets/periskop/FRR-FFR.jpg")
	],
	[cell_type.FREE,cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/FRR-FFF.png"),
		preload("res://assets/periskop/FRR-FFF.jpg")
	],
	[cell_type.FREE,cell_type.ROCK,cell_type.FREE,cell_type.ROCK,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/4.png"),
		preload("res://assets/periskop/4.jpg")
	],
	[cell_type.FREE,cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/FRR-FFR.png"),
		preload("res://assets/periskop/FRR-FFR.jpg")
	],
	[cell_type.FREE,cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/FRF-FFF.png"),
		preload("res://assets/periskop/FRF-FFF.jpg")
	],
	[cell_type.FREE,cell_type.FREE,cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/7.png"),
		preload("res://assets/periskop/7.jpg")
	],
	[cell_type.FREE,cell_type.FREE,cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/8_5.png"),
		preload("res://assets/periskop/8_5.jpg")
	],
	[cell_type.ROCK,cell_type.ROCK,cell_type.FREE,cell_type.ROCK,cell_type.ROCK,cell_type.FREE]: [
		preload("res://assets/periskop/10.png"),
		preload("res://assets/periskop/10.jpg")
	],
	[cell_type.FREE,cell_type.FREE,cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/RFF-FFF.png"),
		preload("res://assets/periskop/RFF-FFF.jpg")
	],
	[cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.ROCK,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/2.png"),
		preload("res://assets/periskop/2.jpg")
	],
	[cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.ROCK,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/FFF-RFF_5.png"),
		preload("res://assets/periskop/FFF-RFF_5.jpg")
	],
	[cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/FFF-RFF.png"),
		preload("res://assets/periskop/FFF-RFF.jpg")
	],
	[cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/1.png"),
		preload("res://assets/periskop/1.jpg")
	],
	[cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.ROCK,cell_type.FREE,cell_type.FREE]: [
		preload("res://assets/periskop/9_5.png"),
		preload("res://assets/periskop/9_5.jpg")
	],
	[cell_type.FREE,cell_type.FREE,cell_type.ROCK,cell_type.FREE,cell_type.FREE,cell_type.ROCK]: [
		preload("res://assets/periskop/9.png"),
		preload("res://assets/periskop/9.jpg")
	],
}

#[0,0],[0,1],[0,2]
#[1,0],[1,1],[1,2]
var _monster_position: Array[CompressedTexture2D] = [
	preload("res://assets/periskop/monsters/YQQQQQ.png") as CompressedTexture2D,
	preload("res://assets/periskop/monsters/QYQQQQ.png") as CompressedTexture2D,
	preload("res://assets/periskop/monsters/QQYQQQ.png") as CompressedTexture2D,
	preload("res://assets/periskop/monsters/QQQYQQ.png") as CompressedTexture2D,
	preload("res://assets/periskop/monsters/ryba.png") as CompressedTexture2D,
	preload("res://assets/periskop/monsters/QQQQQY.png") as CompressedTexture2D
]

func update_visual_state(template: Array[cell_type]) ->void:
	if(template[4] == Cell.cell_type.ROCK):
		visual = preload("res://assets/periskop/10.jpg")
		geo_visual = preload("res://assets/periskop/12.png")
		return
	var tmp_template:Array[cell_type]
	for i: int in range(6):
		tmp_template.append(template[i])
		if(tmp_template[i] != Cell.cell_type.ROCK):
			tmp_template[i] = Cell.cell_type.FREE
	geo_visual = _pattern_to_visual[tmp_template][0]
	visual = _pattern_to_visual[tmp_template][1]

func _get_name_of_cell() -> String:
	if(type == cell_type.FREE):
		return "FREE"
	elif(type == cell_type.ROCK):
		return "ROCK"
	elif(type == cell_type.FINISH):
		return "FINISH"
	elif(type == cell_type.ENEMY):
		return "ENEMY"
	elif(type == cell_type.AIR):
		return "AIR"
	elif(type == cell_type.DESTRUCTABLE):
		return "DESTRUCTABLE"
	elif(type == cell_type._SONAR_OBSCURE):
		return "_SONAR_OBSCURE"
	elif(type == cell_type._SONAR_PLAYER):
		return "_SONAR_PLAYER"
	return "ERROR CELL"
