class_name VirtualPlayer
extends Resource

signal player_dead()

#Coordinate system as is in Godot. +Y faces down.
var player_direction: Vector2 = Vector2(0,1)
@export var hp: int = 2:
	set(value):
		hp = value
		if(hp <= 0):
			player_dead.emit()

func _init()-> void:
	_connect_signals()
	
func _connect_signals() -> void:
	(self as VirtualPlayer).player_dead.connect(_on_player_dead)

func _on_player_dead() -> void:
	print("YOU LOST")
