extends SubViewport

@onready var regular: TextureRect = %Regular
@onready var grid_container: GridCells = %RealGridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	(get_tree().get_nodes_in_group("the_most_important_node")[0] as VirtualEnvironment).vmap.visual_changed.connect(_on_visual_changed)

func _on_visual_changed(in_cell: Cell, template: Array[Cell.cell_type]) -> void:
	self.size = Vector2(4713,3535)
	regular.texture = in_cell.visual
	grid_container._update_grid(template)
