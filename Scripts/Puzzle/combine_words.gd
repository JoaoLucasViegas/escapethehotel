extends Control

@onready var puzzle_manager: GamePuzzle
@onready var keys = $Keys

func _ready() -> void:
	puzzle_manager = get_parent_control()

func _on_button_pressed() -> void:
	var try = ""
	for x in keys.get_children():
		try += x.key
	if try == Global.passphrase:
		puzzle_manager.is_puzzle_finished = true
	$PassError.play()
