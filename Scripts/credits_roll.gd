extends Control

@onready var main_menu_scene = ResourceLoader.load("res://Scenes/main_menu.tscn")

func _ready() -> void:
	get_tree().paused = false

func _on_leave_pressed() -> void:
	if main_menu_scene:
		get_tree().change_scene_to_packed(main_menu_scene)
