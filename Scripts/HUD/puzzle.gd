extends Control

@export var ui_manager: UIManager

func addPuzzle(puzzle: GamePuzzle, obj: Node3D, caller: PuzzleCaller):
	if get_child_count(true) >= 1:
		return
	if obj:
		puzzle.obj_to_react = obj
	puzzle.caller_callback = caller
	add_child(puzzle)
	show()
func clearPuzzles():
	if get_child_count(true) >= 1:
		get_child(0).queue_free()

func _physics_process(_delta: float) -> void:
	if get_child_count(true) <= 0:
		hide()
