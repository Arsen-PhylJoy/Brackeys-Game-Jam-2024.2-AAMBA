extends Sprite3D

@onready var tip: Label = %Tip
@onready var freaking_music: AudioStreamPlayer = %FreakingMusic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	EventBus.event_notificated.connect(_on_event_notificated)
	EventBus.event_done.connect(_on_event_done)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_event_notificated(_in_notif: String) -> void:
	tip.text = str("go to" + _in_notif)
	freaking_music.play()
	self.show()

func _on_event_done() -> void:
	freaking_music.stop()
	self.hide()
