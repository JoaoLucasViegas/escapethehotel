class_name UIManager
extends CanvasLayer

@onready var credits_roll = ResourceLoader.load("res://Scenes/credits_roll.tscn")

var chase_visible = false

func whenGameEnds():
	get_tree().paused = true
	get_tree().change_scene_to_packed(credits_roll)

func _physics_process(delta: float) -> void:
	update_chase_ui(delta)
	
func update_chase_ui(delta: float) -> void:
	var modulate_alpha = $ChaseEffect.modulate.a
	if chase_visible:
		modulate_alpha = move_toward(modulate_alpha, .5, 2 * delta)
	else:
		modulate_alpha = move_toward(modulate_alpha, 0, 2 * delta)
	$ChaseEffect.modulate.a = modulate_alpha

func change_chase_visible(value: bool):
	chase_visible = value
