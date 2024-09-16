extends SubViewport

@export var is_real: bool = false

@onready var regular: TextureRect = %UnrealRegular
@onready var grid_container: GridCells = %UnrealGridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	(get_tree().get_nodes_in_group("the_most_important_node")[0] as VirtualEnvironment).vmap.visual_changed.connect(_on_visual_changed)

func _on_visual_changed(in_cell: Cell, template: Array[Cell.cell_type]) -> void:
		self.size = Vector2(1440,1152)
		regular.texture = in_cell.geo_visual
