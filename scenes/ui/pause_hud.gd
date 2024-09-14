extends CanvasLayer


@onready var _continue_button: Button = %Continue
@onready var _exit_button: Button =  %Exit

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if (self as Node).tree_exiting.connect(_on_free): printerr("Fail: ",get_stack())
	if _continue_button.pressed.connect(_on_continue_pressed): printerr("Fail: ",get_stack())
	if _exit_button.pressed.connect(_on_exit_pressed): printerr("Fail: ",get_stack()) 
	get_tree().paused = true

func _on_continue_pressed()->void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().paused = false
	queue_free()

func _on_exit_pressed()->void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().quit()

func _on_free()->void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
