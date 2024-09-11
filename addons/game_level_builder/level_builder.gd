@tool
extends Control

@onready var matrix_choice: CMatrixChoice = %MatrixChoice
@onready var matrix_drawer: MatrixDrawer = %MatrixDrawer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	matrix_choice.matrix_dimension_selected.connect(_on_matrix_dimension_selected)

func _on_matrix_dimension_selected(dim: int) -> void:
	matrix_drawer._create_matrix(dim)
