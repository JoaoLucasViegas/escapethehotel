class_name GamePuzzle
extends Control

var obj_to_react: Node3D
var caller_callback: PuzzleCaller

var is_puzzle_finished = false

func _physics_process(_delta: float) -> void:
	if is_puzzle_finished:
		if obj_to_react:
			if obj_to_react.has_method("react"):
				obj_to_react.react()
		if caller_callback:
			caller_callback.is_done = true
		self.queue_free()

func _on_leave_puzzle_pressed() -> void:
	hide()
	#self.queue_free()
