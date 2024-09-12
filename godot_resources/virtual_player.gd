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

@export var air: int = 10:
	set(value):
		air = value
		EventBus.on_air_value_change.emit(air)
		if(air <= 0):
			player_dead.emit()
@export var torpedos: int = 2

@export var air_refill_amount: int = 2
@export var damage_from_rocks: int = 1
@export var damage_from_destructables: int = 1
@export var damage_from_enemies: int = 2
@export var after_burner: int = 2

func _init()-> void:
	_connect_signals()

func _connect_signals() -> void:
	(self as VirtualPlayer).player_dead.connect(_on_player_dead)

func _on_player_dead() -> void:
	print("YOU LOST")
