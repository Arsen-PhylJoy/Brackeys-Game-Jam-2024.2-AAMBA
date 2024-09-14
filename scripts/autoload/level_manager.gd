extends Node

signal transition_finished

var loading_screen: LoadingScreen
var _loading_screen_scene: PackedScene = preload("res://scenes/ui/loading_screen.tscn")

var current_level_path: String = ""
var current_level: Resource = null

var levels: Dictionary = {
	"level_1": "res://godot_resources/vmap_levels/level_y.tres",
	"level_2": "res://godot_resources/vmap_levels/level_xy.tres"
}

@onready var virtual_env: VirtualEnvironment

func _ready() -> void:
	load_level("level_1")

func load_level(level_name: String) -> void:
	if levels.has(level_name):
		var level_path: String = levels[level_name]
		if current_level_path != level_path:
			unload_current_level()
			current_level_path = level_path
			current_level = load(level_path)
			apply_vmap(current_level)
			print("Level loaded: ", level_name)
		else:
			print("Level is already loaded: ", level_name)
	else:
		print("Level not found: ", level_name)

func apply_vmap(current_level: Resource) -> void:
	virtual_env.vmap = current_level

func unload_current_level() -> void:
	if current_level:
		current_level = null
		current_level_path = ""
		print("Level unloaded")

func reload_current_level() -> void:
	if current_level_path:
		unload_current_level()
		load_level(current_level_path)
		print("Level reloaded")


#func _ready() -> void:
	#print(get_tree().current_scene.name)
	#
#func load_level(level_path: String, transition_name: String = "fade_to_black") -> void:
	#_level_scene = load(level_path)
	#_transition_name = transition_name
	#_start_load_level()
	#
#func _start_load_level() -> void:
	#loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
	#get_tree().root.add_child(loading_screen)
	#if(!loading_screen.transition_in_ended.is_connected(_on_transition_in_ended)):
		#if loading_screen.transition_in_ended.connect(_on_transition_in_ended): printerr("Fail: ",get_path()) 
	#loading_screen.start_transition(_transition_name)
	#
#func _end_load_level() -> void:
	#get_tree().change_scene_to_packed(_level_scene)
	#transition_finished.emit()
	#await loading_screen.finish_transition()
#
#func _on_transition_in_ended() -> void:
	#_end_load_level()
