extends CanvasLayer


@onready var _restart: Button =  %restart

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if _restart.pressed.connect(_on_restarted): printerr("Fail: ",get_stack())
	if self.tree_exiting.connect(_on_exiting): printerr("Fail: ",get_stack())
	get_tree().paused = true

func _on_restarted()->void:
	LevelManager.load_level(Global.levels[Global.index_current_level])

func _on_exiting() -> void:
	get_tree().paused = false
