@tool
extends EditorPlugin

var level_builder: PackedScene = preload("res://addons/game_level_builder/level_builder.tscn")

var  main_panel_instance: Control

func _enter_tree():
	main_panel_instance = level_builder.instantiate() as Control
	EditorInterface.get_editor_main_screen().add_child(main_panel_instance)
	_make_visible(false)


func _exit_tree():
	if main_panel_instance:
		main_panel_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if main_panel_instance:
		main_panel_instance.visible = visible


func _get_plugin_name():
	return "Level Builder"


func _get_plugin_icon():
	return EditorInterface.get_editor_theme().get_icon("Node", "EditorIcons")
