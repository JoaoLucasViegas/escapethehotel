class_name DevToolsScript extends Node

var console_str = ""

@onready var debug_ui = $DebugUI

var is_debugging = false

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_tools"):
		is_debugging = not is_debugging
	
	debug_ui.visible = is_debugging

func consoleText(... args: Array):
	var text = ""
	for arg in args:
		text += str(arg)
	console_str += text
	console_str += "\n"
	debug_ui.addConsoleStr(text)
	#debug_ui.updateConsole()
