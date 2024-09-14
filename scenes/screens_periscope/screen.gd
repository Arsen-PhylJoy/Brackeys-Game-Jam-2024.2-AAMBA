class_name  ScreenSubViewport
extends SubViewport

@export var is_geo: bool = true

@onready var regular: TextureRect = %Regular
@onready var grid_container: GridCells = %GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	for node: Node in get_tree().current_scene.get_children():
		if(node is VirtualEnvironment):
			(node as VirtualEnvironment).vmap.visual_changed.connect(_on_visual_changed)

func _on_visual_changed(in_cell: Cell, template: Array[Cell.cell_type]) -> void:
	if(!is_geo):
		self.size = Vector2(4713,3535)
		regular.texture = in_cell.visual
		grid_container._update_grid(template)
	else:
		self.size = Vector2(1440,1152)
		regular.texture = in_cell.geo_visual