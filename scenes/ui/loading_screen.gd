class_name LoadingScreen 
extends CanvasLayer

@onready var color_rect: ColorRect = %ColorRect
@onready var anim_player: AnimationPlayer = %AnimationPlayer

var starting_animation_name: String

func _ready() -> void:
	color_rect.visible = false
	anim_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_to_black":
		EventBus.on_transition_ended.emit()
		anim_player.play("fade_to_normal")
	elif anim_name == "fade_to_normal":
		color_rect.visible = false

func transition() -> void:
	color_rect.visible = true
	anim_player.play("fade_to_black")
	pass
