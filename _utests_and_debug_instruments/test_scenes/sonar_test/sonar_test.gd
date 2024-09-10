extends CanvasLayer

@onready var _plus_radius: Button = %"+Radius"
@onready var _minus_radius: Button = %"-Radius"
@onready var sonar: Sonar = %Sonar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	_plus_radius.pressed.connect(_on_plus_rad_pressed)
	_minus_radius.pressed.connect(_on_min_rad_pressed)

func _on_plus_rad_pressed() -> void:
	sonar._sonar_radius+=1

func _on_min_rad_pressed() -> void:
	sonar._sonar_radius-=1
