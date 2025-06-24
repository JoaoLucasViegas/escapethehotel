extends Control

@onready var main_menu_scene = ResourceLoader.load("res://Scenes/main_menu.tscn")

var fading = false

func _ready() -> void:
	Global.connect("GameOver", _fading, CONNECT_DEFERRED)

func _physics_process(delta: float) -> void:
	if fading:
		$RestartBtn.modulate.a = move_toward($RestartBtn.modulate.a, 1, delta)
		$MainMenuBtn.modulate.a = move_toward($MainMenuBtn.modulate.a, 1, delta)
		$Label.modulate.a = move_toward($Label.modulate.a, 1, delta)

func _fading():
	$Label.hide()
	$ReadingMessage.start()
	$RestartBtn.hide()
	$MainMenuBtn.hide()
	$Label.modulate.a = 0
	$RestartBtn.modulate.a = 0
	$MainMenuBtn.modulate.a = 0

func _on_restart_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	hide()

func _on_main_menu_btn_pressed() -> void:
	if main_menu_scene:
		get_tree().change_scene_to_packed(main_menu_scene)

func _on_reading_message_timeout() -> void:
	fading = true
	$Label.show()
	$RestartBtn.show()
	$MainMenuBtn.show()
