extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_interactable_focused(interactor: Interactor) -> void:
	print("left - focused")

func _on_interactable_interacted(interactor: Interactor) -> void:
	print("left - interacted")

func _on_interactable_unfocused(interactor: Interactor) -> void:
	print("left - unfocused")
