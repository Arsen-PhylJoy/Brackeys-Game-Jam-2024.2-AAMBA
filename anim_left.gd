class_name LeftButton
extends Node3D

signal for_system_emitted()

var _is_button_down: bool = false
@onready var left_sound_button: AudioStreamPlayer3D = %LeftSoundButton
@onready var animation_left: AnimationPlayer = %AnimationLeft

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_left.animation_finished.connect(_on_rocket_anim_finished)

func _on_interactable_focused(interactor: Interactor) -> void:
	((%left as MeshInstance3D).material_overlay as ShaderMaterial).set_shader_parameter("is_turn_off", false)

func _on_interactable_interacted(interactor: Interactor) -> void:
	if(animation_left.is_playing() or _is_button_down):
		return
	_is_button_down = true
	animation_left.play("left_on")
	for_system_emitted.emit()
	left_sound_button.play()

func _on_interactable_unfocused(interactor: Interactor) -> void:
	((%left as MeshInstance3D).material_overlay as ShaderMaterial).set_shader_parameter("is_turn_off", true)

func _on_rocket_anim_finished(_anim_name: String) -> void:
	if(_is_button_down):
		animation_left.play("left_off")
		_is_button_down = false
