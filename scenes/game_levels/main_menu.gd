extends Node3D

@onready var play: Button = %Play
@onready var main_menu_music: AudioStreamPlayer = %MainMenuMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	play.pressed.connect(_on_play_pressed)

func _on_play_pressed() -> void:
	Global.index_current_level+=1
	LevelManager.load_level(Global.levels[Global.index_current_level])