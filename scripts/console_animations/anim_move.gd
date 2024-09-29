class_name  MoveButton
extends Node3D

signal for_system_emitted()

var _is_button_down: bool = false
@onready var move_button_sound: AudioStreamPlayer3D = %MoveButtonSound
@onready var animation_move: AnimationPlayer = %AnimationMove


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_move.animation_finished.connect(_on_rocket_anim_finished)

func _on_interactable_focused(interactor: Interactor) -> void:
	((%move as MeshInstance3D).material_overlay as ShaderMaterial).set_shader_parameter("is_turn_off", false)

func _on_interactable_interacted(interactor: Interactor) -> void:
	if(animation_move.is_playing() or _is_button_down):
		return
	_is_button_down = true
	animation_move.play("move_on")
	for_system_emitted.emit()
	move_button_sound.play()

func _on_interactable_unfocused(interactor: Interactor) -> void:
	((%move as MeshInstance3D).material_overlay as ShaderMaterial).set_shader_parameter("is_turn_off", true)

func _on_rocket_anim_finished(_anim_name: String) -> void:
	if(_is_button_down):
		animation_move.play_backwards("move_on")
		_is_button_down = false
