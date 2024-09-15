extends Node3D

signal screamer_2_set()

@onready var interactable: Interactable = %Interactable

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_interactable_focused(interactor: Interactor) -> void:
	pass

func _on_interactable_interacted(interactor: Interactor) -> void:
	pass

func _on_interactable_unfocused(interactor: Interactor) -> void:
	pass
