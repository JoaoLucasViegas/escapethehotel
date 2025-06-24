extends Control

@onready var puzzle_manager: GamePuzzle

func _ready() -> void:
	puzzle_manager = get_parent_control()
	if puzzle_manager:
		puzzle_manager.is_puzzle_finished = true
