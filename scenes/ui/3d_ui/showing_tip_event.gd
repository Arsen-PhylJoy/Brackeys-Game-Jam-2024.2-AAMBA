extends Sprite3D

@onready var tip: Label = %Tip

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.event_notificated.connect(_on_event_notificated)
	EventBus.event_done.connect(_on_event_done)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_event_notificated(_in_notif: String) -> void:
	self.show()

func _on_event_done() -> void:
	self.hide()
