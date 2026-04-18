extends Node3D

@export var to_follow: Node3D = null

@onready var camera = $Camera3D

func _ready() -> void:
	if not to_follow:
		queue_free()
		set_physics_process(false)

func _physics_process(_delta: float) -> void:
	var tween = create_tween()
	tween.tween_property(self, "global_position", to_follow.global_position, .43)
	
	#global_position = to_follow.global_position
