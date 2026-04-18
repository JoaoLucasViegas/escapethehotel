class_name UIManager
extends CanvasLayer

@onready var credits_roll = ResourceLoader.load("res://Scenes/credits_roll.tscn")

func whenGameEnds():
	get_tree().paused = true
	get_tree().change_scene_to_packed(credits_roll)
