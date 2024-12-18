extends Node

@onready var timer: Timer = %Timer
@onready var monster: Node3D = %Monster
@onready var animation_player: AnimationPlayer = $Monster/AnimationPlayer
@onready var screamer_1: Area3D = %Screamer1
@onready var screamer_2: Area3D = %Screamer2

var screamer_1_shown: bool = false
var screamer_2_shown: bool = false

func _ready() -> void:
	monster.visible = false
	screamer_1.body_entered.connect(_on_screamer_1_body_entered)
	screamer_2.body_entered.connect(_on_screamer_2_body_entered)
	EventBus.screamer_2_set.connect(_on_screamer_2_set)
	timer.timeout.connect(_on_timer_timeout)
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_screamer_1_body_entered(body: Node) -> void:
	if screamer_1_shown == false:
		var character_body: CharacterBody3D = body as CharacterBody3D
		if character_body:
			animation_player.play("turn_90_001")
			monster.visible = true
			monster.rotation = Vector3(0, 0, 0)
			monster.position = Vector3(0.361, 2.637, 3.594)
			screamer_1_shown = true
			EventBus.event_notificated.emit("run to reactor")

func _on_screamer_2_set() -> void:
	screamer_2.monitorable = true
	screamer_2.monitoring = true

func _on_screamer_2_body_entered(body: Node) -> void:
	if screamer_2_shown == false:
		var character_body: CharacterBody3D = body as CharacterBody3D
		if character_body:
			animation_player.play("runrun")
			monster.visible = true
			monster.rotation = Vector3(0, -135, 0)
			monster.position = Vector3(0.361, 5.033, -2.768)
			screamer_2_shown = true

func _on_timer_timeout() -> void:
	monster.visible = false

func _on_animation_finished(anim_name: String) -> void:
	monster.visible = false
