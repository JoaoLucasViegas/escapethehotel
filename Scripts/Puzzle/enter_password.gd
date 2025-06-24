extends Control

@onready var puzzle_manager: GamePuzzle
@onready var label = $Label
@onready var timer = $TryTimeout
@onready var timer_keys = $KeyTimeout

var correct_pass = false
var pass_code: String = "-1"

func _ready() -> void:
	puzzle_manager = get_parent_control()
	if puzzle_manager.caller_callback.is_secondary:
		pass_code = Global.vault_code
	else:
		pass_code = Global.pass_code

func _physics_process(_delta: float) -> void:
	if not timer_keys.is_stopped():
		return
	if label.text.length() >= 4:
		if pass_code == label.text:
			passCodeWon()
		else:
			passCodeWrong()

func passCodeWon():
	$LeavePuzzle.hide()
	if not timer.is_stopped():
		return
	if timer.is_stopped():
		timer.start()
	label.text = "CORRECT"
	correct_pass = true
	$PassWon.play()
func passCodeWrong():
	if not timer.is_stopped():
		return
	if timer.is_stopped():
		timer.start()
	label.text = "INCORRECT"
	$PassError.play()

func _on_button_pressed(number_pressed: String) -> void:
	if not timer_keys.is_stopped():
		return
	
	if label.text.length() >= 0 and label.text.length() <= 3:
		#try key
		label.text += number_pressed
		timer_keys.start()
		$KeySound.pitch_scale = randf_range(1.25, 1.45)
		$KeySound.play()


func _on_try_timeout_timeout() -> void:
	if correct_pass:
		puzzle_manager.is_puzzle_finished = true
		return
	#clear label if incorrect
	label.text = ""
