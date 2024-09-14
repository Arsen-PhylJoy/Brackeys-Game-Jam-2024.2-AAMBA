extends Node

var _lost_screen: PackedScene = preload("res://scenes/ui/game_lost.tscn")

func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	for node: Node in get_tree().current_scene.get_children():
		if(node is VirtualEnvironment):
			(node as VirtualEnvironment)._player.player_dead.connect(_on_player_dead)
			(node as VirtualEnvironment).player_won.connect(_on_player_won)

func _on_player_dead() -> void:
	var lost_screen_handler: CanvasLayer = _lost_screen.instantiate()
	get_tree().current_scene.add_child(lost_screen_handler)

func _on_player_won() -> void:
	Global.index_current_level+=1
	if( Global.index_current_level == Global.levels.size()):
		Global.index_current_level = 0
		LevelManager.load_level(Global.levels[Global.index_current_level])
	LevelManager.load_level(Global.levels[Global.index_current_level])
