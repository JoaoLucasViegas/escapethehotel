extends Control

@onready var puzzle_manager: GamePuzzle
@onready var texture = $DoorGrab/Texture
@onready var fork_texture = $DoorTextureRect/Fork/Fork
@onready var key_texture = $DoorTextureRect/Key/Key

@export var door_speed = 0.6
@export var door_angle_back = 45
var max_speed_mouse: float

func _ready() -> void:
	puzzle_manager = get_parent_control()
	max_speed_mouse = get_viewport_rect().size.x/2
	
	if puzzle_manager.caller_callback.is_secondary:
		fork_texture.hide()
		key_texture.show()
	else:
		key_texture.hide()
		fork_texture.show()

func _input(event: InputEvent) -> void:
	if puzzle_manager.is_puzzle_finished:
		return
	if puzzle_manager.caller_callback.is_secondary:
		door_speed = 2
	
	var mousemotion = event as InputEventMouseMotion
	if mousemotion and self.visible:
		var mouseX = abs(mousemotion.relative.length())
		mouseX = clampf(mouseX, 0.001, max_speed_mouse)
		if mouseX != 0:
			var return_speed = randf_range(door_angle_back, 90)
			return_speed = clampf(return_speed, door_angle_back, randf_range(door_angle_back, 90))
			texture.rotation_degrees -= return_speed
			texture.rotation_degrees += mouseX * door_speed
		texture.rotation_degrees = clampf(texture.rotation_degrees, -90, 0)
		#print(texture.rotation, " | ", texture.rotation_degrees, " | ", mouseX)
		if puzzle_manager.caller_callback.is_secondary:
			key_texture.position.x = randf_range(-1, 1)
			key_texture.position.y = randf_range(-1, 1)
		else:
			fork_texture.position.x = randf_range(-1, 1)
			fork_texture.position.y = randf_range(-1, 1)
	
	if texture.rotation_degrees >= 0:
		puzzle_manager.is_puzzle_finished = true
