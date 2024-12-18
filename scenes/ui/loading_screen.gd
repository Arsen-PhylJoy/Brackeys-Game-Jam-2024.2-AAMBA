class_name LoadingScreen extends CanvasLayer

signal transition_in_ended

@onready var anim_player: AnimationPlayer = %AnimationPlayer
var starting_animation_name:String
@onready var bg: TextureRect = %BG
@onready var color_rect: ColorRect = %ColorRect

func _ready() -> void:
	bg.hide()

func start_transition(animation_name:String) -> void:
	bg.show()
	if !anim_player.has_animation(animation_name):
		push_warning("'%s' animation does not exist" % animation_name)
		animation_name = "fade_to_black"
	starting_animation_name = animation_name
	anim_player.play(animation_name)
	await anim_player.animation_finished
	transition_in_ended.emit()
	
# called by SceneManger to play the outro to the transition once the content is loaded
func finish_transition() -> void:
	bg.hide()
	# construct second half of the transitation's animation name
	var ending_animation_name:String = starting_animation_name.replace("to","from")
	if !anim_player.has_animation(ending_animation_name):
		push_warning("'%s' animation does not exist" % ending_animation_name)
		ending_animation_name = "fade_to_normal"
	anim_player.play(ending_animation_name)
	await anim_player.animation_finished
	get_tree().paused = false
	bg.hide()
