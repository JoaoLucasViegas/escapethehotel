class_name AreaInteract extends Area3D

var can_interact = false
var label3d: Label3D

@export var interaction_component: InteractionComponent = null
@export var label_string: String = ""

func _ready() -> void:
	if not interaction_component:
		queue_free()
		set_physics_process(false)
		return
	label3d = get_node("Label3D")
	label3d.text = label_string

func _physics_process(_delta: float) -> void:
	if can_interact and get_overlapping_bodies().is_empty():
		label3d.hide()
		can_interact = false
		set_physics_process(false)
		interaction_component.cancel()
		return
	
	if get_overlapping_bodies():
		if Input.is_action_just_pressed("game_interact"):
			interaction_component.start()
			label3d.hide()
		if Input.is_action_just_pressed("move_boost") \
		or Input.is_action_just_pressed("ui_cancel"):
			interaction_component.cancel()
			label3d.show()

func _on_body_entered(body) -> void:
	if body:
		can_interact = true
		set_physics_process(true)
		label3d.show()
