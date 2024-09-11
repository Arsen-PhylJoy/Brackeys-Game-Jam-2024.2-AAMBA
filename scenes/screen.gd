extends Node3D

@onready var air_bar_3d: ProgressBar = %AirBar3D
@onready var _screen_mesh: MeshInstance3D = %ScreenMesh

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	EventBus.on_air_value_change.connect(air_counter)
	for node: Node in get_tree().current_scene.get_children():
		if(node is VirtualEnvironment):
			(node as VirtualEnvironment).forward_visual_changed.connect(_on_forward_visual_changed)

func _on_forward_visual_changed(in_cell: Cell) -> void:
	(_screen_mesh.get_surface_override_material(0) as ShaderMaterial).set_shader_parameter("visual", in_cell.visual)

func air_counter(air: int) -> void:
	air_bar_3d.value = air
