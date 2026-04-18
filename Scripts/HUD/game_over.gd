extends Control

@onready var main_menu_scene = ResourceLoader.load("res://Scenes/main_menu.tscn")

var fading = false

func _ready() -> void:
	Global.connect("GameOver", _fading, CONNECT_DEFERRED)

func _physics_process(_delta: float) -> void:
	if fading:
		fading = false
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color.WHITE, 1)
	
	if modulate.a >= 1:
		$ColorRect.mouse_filter = Control.MOUSE_FILTER_IGNORE

func _fading():
	hide()
	modulate.a = 0
	$ColorRect.mouse_filter = Control.MOUSE_FILTER_STOP
	fading = true
	show()
	
func _on_restart_btn_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
	hide()

func _on_main_menu_btn_pressed() -> void:
	if main_menu_scene:
		get_tree().change_scene_to_packed(main_menu_scene)
	
