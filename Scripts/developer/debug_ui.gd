extends Control

@onready var console_label = $Console
@onready var viewport_label = $Viewport

var console_str = []

func _ready() -> void:
	console_label.text = ""

func _physics_process(_delta: float) -> void:
	update_ui()

func addConsoleStr(x: Variant):
	console_str.append(x)
	updateConsole()

func updateConsole():
	console_label.text = ""
	for output in console_str:
		console_label.text += str(output)

func update_ui():
	viewport_label.text = ""
	
	var viewport_text = str(
		int(get_viewport_rect().size.x),"x", int(get_viewport_rect().size.y),
		"|FPS: ",
		Performance.get_monitor(Performance.TIME_FPS)
	)
	viewport_label.text = viewport_text

func _on_clear_output_button_pressed() -> void:
	console_str = []
	updateConsole()

func _on_restart_level_pressed() -> void:
	get_tree().reload_current_scene()
