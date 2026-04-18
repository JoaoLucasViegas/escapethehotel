class_name DoorLevel extends Node3D

@onready var door_area = $AreaSight
@onready var door_label = $Label3D
@onready var door_gizmo = $DoorGizmo

@export var close_angle: float = 0
@export var open_angle: float = -90
@export var action_speed: float = 180 #Angles/mileseconds I guess

@export var is_open = false
@export var is_unlocked = false
@export var is_final = false

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
	
	door_label.visible = door_area.is_there_collision and is_unlocked
	
	if door_area.is_there_collision and is_unlocked:
		if Input.is_action_just_pressed("game_interact"):
			is_open = !is_open
			$HingeSound.pitch_scale = randf_range(1.0, 1.18)
			$HingeSound.play()
			if is_final:
				Global.emit_game_end()

func unlock():
	is_unlocked = true
	if not is_final:
		$UnlockSound.play()
