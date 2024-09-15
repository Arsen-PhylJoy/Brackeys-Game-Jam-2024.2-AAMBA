extends Control

@onready var hp_label: Label = %HPLabel
@onready var air_label: Label = %AirLabel
@onready var torpedos_label: Label = %TorpedosLabel
@onready var afterburner_label: Label = %AfterburnerLabel
@onready var notif: Label = %Notif
@onready var info: VBoxContainer = %Info

var _hp: int
var _air: int
var _torpodos: int
var _afterburner: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_connect_signals()

func _connect_signals() -> void:
	(get_tree().get_nodes_in_group("the_most_important_node")[0] as VirtualEnvironment)._player.data_changed.connect(_on_data_changed)
	EventBus.event_notificated.connect(_on_event_notificated)
	EventBus.event_done.connect(_on_event_done)

func _on_data_changed(hp: int, air: int, torpedos: int, afterburner: int) -> void:
	hp_label.text = str("Armor points: " + str(hp))
	air_label.text = str("Air left: " + str(air))
	torpedos_label.text = str("Torpedos left: " + str(torpedos))
	afterburner_label.text = str("Afterburner left: " + str(afterburner))

func _on_event_notificated(in_notif: String) -> void:
	notif.text = in_notif
	notif.show()
	info.hide()

func _on_event_done() -> void:
	notif.hide()
	info.show()
