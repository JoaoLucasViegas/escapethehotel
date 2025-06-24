extends Node3D

@export var boom_scale = 2.0
@export var boom_speed = 1.0
@export var boom_fade_speed = 1.0
@export var obj_to_react: Node3D

var activated = false
var is_exploded = false
var boom_vector = Vector3.ONE
var boom_sound = false

func _ready() -> void:
	boom_vector *= boom_scale

func _physics_process(delta: float) -> void:
	visible = activated
	if activated:
		if is_exploded:
			if not boom_sound:
				$Explode.play()
				boom_sound = true
			if scale != Vector3.ZERO:
				scale.x = move_toward(scale.x, 0, boom_fade_speed * delta)
				scale.y = move_toward(scale.y, 0, boom_fade_speed * delta)
				scale.z = move_toward(scale.z, 0, boom_fade_speed * delta)
			if scale == Vector3.ZERO:
				if obj_to_react and obj_to_react.has_method("react"):
					obj_to_react.react()
				queue_free()
		else:
			if scale != boom_vector:
				scale.x = move_toward(scale.x, boom_vector.x, boom_speed * delta)
				scale.y = move_toward(scale.x, boom_vector.y, boom_speed * delta)
				scale.z = move_toward(scale.x, boom_vector.z, boom_speed * delta)
			if scale == boom_vector:
				is_exploded = true

func react():
	activated = true
	
