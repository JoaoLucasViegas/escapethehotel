extends Control

@onready var game_scene = ResourceLoader.load("res://Scenes/world.tscn")
@onready var credits_roll = ResourceLoader.load("res://Scenes/credits_roll.tscn")

func _ready() -> void:
	get_tree().paused = false

func _on_new_game_btn_pressed() -> void:
	if game_scene:
		Global.startGame()
		get_tree().change_scene_to_packed(game_scene)


func _on_credits_btn_pressed() -> void:
	if game_scene:
		get_tree().change_scene_to_packed(credits_roll)
