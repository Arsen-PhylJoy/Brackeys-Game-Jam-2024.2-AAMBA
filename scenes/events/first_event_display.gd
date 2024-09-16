extends Node3D

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_interactable_focused(interactor: Interactor) -> void:
	pass

func _on_interactable_interacted(interactor: Interactor) -> void:
	EventBus.screamer_2_set.emit()
	print("123123")

func _on_interactable_unfocused(interactor: Interactor) -> void:
	pass
