@tool
class_name  CMatrixChoice
extends Control

signal matrix_dimension_selected(dimension: int)

@onready var _matrix_d_option_button: OptionButton = %MatrixDOptionButton
@onready var _make_matrix_of_selected_dimensions: Button = %Make_Matrix_Of_Selected_Dimensions

var max_dim: int = 25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()
	max_dim+=1
	_matrix_d_option_button.clear()
	for i: int in range(max_dim):
		_matrix_d_option_button.add_item("Select " + str(i+4) + " dimensions", i)
		_matrix_d_option_button.set_item_metadata(i, i+4 as int)
	##TODO useless items are not deleted

func _connect_signals() -> void:
	_make_matrix_of_selected_dimensions.pressed.connect(_on_pressed)
	_matrix_d_option_button.item_selected.connect(_on_item_selected)

func _on_pressed() -> void:
	matrix_dimension_selected.emit(_matrix_d_option_button.get_selected_metadata())

func _on_item_selected(index: int) -> void:
	_make_matrix_of_selected_dimensions.text = "Create " + str(_matrix_d_option_button.get_selected_metadata()) + " dimensional matrix."
