extends MeshInstance3D

@onready var screen: ScreenSubViewport = %Screen
@export var _is_geometry: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	screen.is_geo = _is_geometry
	((self as MeshInstance3D).get_active_material(0) as StandardMaterial3D).albedo_texture = screen.get_texture()
