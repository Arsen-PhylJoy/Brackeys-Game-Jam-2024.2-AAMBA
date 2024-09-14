extends Node3D

@onready var play: Button = %Play
@onready var sound_settings: Button = %SoundSettings
@onready var main_menu_music: AudioStreamPlayer = %MainMenuMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	play.pressed.connect(_on_play_pressed)
	sound_settings.pressed.connect(_on_sound_settings_pressed)

func _on_play_pressed() -> void:
	Global.index_current_level+=1
	LevelManager.load_level(Global.levels[Global.index_current_level])

func _on_sound_settings_pressed() -> void:
	pass
