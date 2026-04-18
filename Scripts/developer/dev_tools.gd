class_name DevToolsScript extends Node

@onready var debug_ui = $DebugUI

var is_debugging = false

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("debug_tools"):
		is_debugging = not is_debugging
	
	debug_ui.visible = is_debugging

func consoleText(... args: Array):
	for arg in args:
		debug_ui.addConsoleStr(arg)
	debug_ui.addConsoleStr("\n")
