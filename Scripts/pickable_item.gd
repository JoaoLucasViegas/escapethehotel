class_name Item
extends Node3D

@onready var door_area = $AreaSight
@onready var door_label = $Label3D

@export var level_manager: LevelManager
@export var item_icon: Texture
@export var item_name: String = "Item"
@export var item_spawn_point: Marker3D
@export var obj_to_react: Node3D

func _physics_process(_delta: float) -> void:
	if item_spawn_point:
		hide()
		return
	door_label.visible = door_area.is_there_collision
	
	if door_area.is_there_collision:
		if Input.is_action_just_pressed("game_interact"):
			level_manager.pickedItem(self)

func react():
	if item_spawn_point:
		show()
		global_position = item_spawn_point.global_position
		item_spawn_point = null
