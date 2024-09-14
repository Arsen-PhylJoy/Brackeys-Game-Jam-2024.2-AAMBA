extends Node3D

@export var min_db: float = 0
@export var max_db: float = 50

@onready var audio_player: AudioStreamPlayer3D = %AudioStreamPlayer3D

func _ready() -> void:
	audio_player.playing = true
	_connect_signals()

func _connect_signals() -> void:
	for node: Node in get_tree().current_scene.get_children():
		if node is VirtualEnvironment:
			(node as VirtualEnvironment).virtual_map_relative_to_player_updated.connect(_on_virtual_map_relative_to_player_updated)

func _on_virtual_map_relative_to_player_updated(vmap: VirtualMap, player_pos: Vector2, player_dir: Vector2) -> void:
	var _max_distance_from_finish: float = Vector2(0,0).distance_to(Vector2(vmap.get_columns()+1,vmap.get_columns()+1))
	var _distance_from_finish:float = player_pos.distance_to(vmap.get_position_of_nearest_finish(player_pos))
	print(str((_max_distance_from_finish - _distance_from_finish)) +"!!!"+ str(_max_distance_from_finish))
	audio_player.volume_db = lerpf(max_db, min_db,  _max_distance_from_finish/(_max_distance_from_finish - _distance_from_finish))
	print(audio_player.volume_db)
