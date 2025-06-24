extends Node3D

@onready var door_gizmo = $DoorGizmo

@export var close_angle: float = 0
@export var open_angle: float = -90
@export var action_speed: float = 5 #Angles/mileseconds I guess

@export var is_open = false

func _ready() -> void:
	if not door_gizmo:
		set_process(false)

func _physics_process(delta: float) -> void:
	if door_gizmo:
		if is_open:
			door_gizmo.rotation_degrees.y = move_toward(
				door_gizmo.rotation_degrees.y, open_angle, action_speed * delta)
		else:
			door_gizmo.rotation_degrees.y = move_toward(
				door_gizmo.rotation_degrees.y, close_angle, action_speed * delta)

func react():
	is_open = true
	$PassWon.play()
