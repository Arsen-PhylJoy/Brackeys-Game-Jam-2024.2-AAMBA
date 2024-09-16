extends Node

@onready var back_calm: AudioStreamPlayer = %BackCalm
@export var random_amb_interval: float = 42
@onready var ambients: AudioStreamPlayer = %Ambients
@onready var amb_timer: Timer = %AmbTimer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.event_done.connect(_on_event_done)
	EventBus.event_notificated.connect(_on_event_notificated)
	amb_timer.timeout.connect(_on_amb_timeout)

func _on_event_notificated(str: String) -> void:
	back_calm.stop()

func _on_event_done() -> void:
	pass

func _on_amb_timeout() -> void:
	ambients.play()
	amb_timer.start(random_amb_interval)
