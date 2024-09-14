extends Node

signal transition_finished

var loading_screen: LoadingScreen
var _loading_screen_scene:PackedScene = preload("res://scenes/ui/loading_screen.tscn")
var _transition_name:String
var _level_scene:PackedScene
var the_level_path: String

func _ready() -> void:
	print(get_tree().current_scene.name)
	
func load_level(level_path:String, transition_name:String="fade_to_black") -> void:
	_transition_name = transition_name
	_start_load_level()
	the_level_path = level_path
	
func _start_load_level()-> void:
	if(loading_screen != null):
		return
	loading_screen = _loading_screen_scene.instantiate() as LoadingScreen
	get_tree().root.add_child(loading_screen)
	if(!loading_screen.transition_in_ended.is_connected(_on_transition_in_ended)):
		if loading_screen.transition_in_ended.connect(_on_transition_in_ended): printerr("Fail: ",get_path()) 
	loading_screen.start_transition(_transition_name)
	
func _end_load_level()-> void:
	@warning_ignore("return_value_discarded")
	get_tree().change_scene_to_packed(_level_scene)
	transition_finished.emit()
	await loading_screen.finish_transition()
	get_tree().root.remove_child(loading_screen)
	loading_screen.queue_free()

func _on_transition_in_ended()->void:
	_level_scene = load(the_level_path)
	_end_load_level()
