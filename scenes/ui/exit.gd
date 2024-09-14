extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	self.pressed.connect(_on_exit_pressed)

func _on_exit_pressed() -> void:
	get_tree().quit()
