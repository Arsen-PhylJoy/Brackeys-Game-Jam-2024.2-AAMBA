class_name RocketButton
extends Node3D

signal for_system_emitted()

@onready var animation_rocket: AnimationPlayer = %AnimationRocket
@onready var torpedo_player_button: AudioStreamPlayer3D = %torpedo_player_button
@onready var torpedo_player_launch: AudioStreamPlayer3D = %torpedo_player_launch
var launch_sound: AudioStreamMP3 = preload("res://assets/sfx/Ne music/Пуск торпеды.mp3") 

var _is_button_down: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_rocket.animation_finished.connect(_on_rocket_anim_finished)
	torpedo_player_button.finished.connect(_on_rocket_button_sound_finished)
	torpedo_player_launch.finished.connect(_on_rocket_launch_sound_finished)

func _on_interactable_focused(interactor: Interactor) -> void:
	((%fire as MeshInstance3D).material_overlay as ShaderMaterial).set_shader_parameter("is_turn_off", false)

func _on_interactable_interacted(interactor: Interactor) -> void:
	if(animation_rocket.is_playing() or _is_button_down):
		return
	_is_button_down = true
	animation_rocket.play("rocket_on")
	torpedo_player_button.play()

func _on_interactable_unfocused(interactor: Interactor) -> void:
	((%fire as MeshInstance3D).material_overlay as ShaderMaterial).set_shader_parameter("is_turn_off", true)

func _on_rocket_anim_finished(_anim_name: String) -> void:
	if(_is_button_down):
		animation_rocket.play_backwards("rocket_on")
		_is_button_down = false

func _on_rocket_button_sound_finished() -> void:
	torpedo_player_launch.play()

func _on_rocket_launch_sound_finished() -> void:
	for_system_emitted.emit()
