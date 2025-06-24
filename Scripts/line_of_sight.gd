class_name AreaSight
extends Area3D

var is_there_collision = false
var overlapping_body_name = ""

func _physics_process(_delta: float) -> void:
	is_there_collision = true if has_overlapping_bodies() else false
	if is_there_collision:
		overlapping_body_name = get_overlapping_bodies()[0].name
