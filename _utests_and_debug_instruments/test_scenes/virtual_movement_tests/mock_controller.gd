extends Node

@onready var _cooldown: Timer = %cooldown

func _process(_delta: float) -> void:
	if(_cooldown.is_stopped()):
		if(Input.is_key_pressed(KEY_W)):
			_cooldown.start()
			EventBus.player_moved.emit()
		if(Input.is_key_pressed(KEY_A)):
			_cooldown.start()
			EventBus.player_turned_left.emit()
		if(Input.is_key_pressed(KEY_D)):
			_cooldown.start()
			EventBus.player_turned_right.emit()
