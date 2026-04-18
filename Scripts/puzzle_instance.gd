class_name PuzzleCaller
extends Node3D

@onready var puzzle_area = $AreaSight
@onready var puzzle_label = $Label3D

@export var level_manager: LevelManager
@export var object_to_react: Node3D
@export var puzzle: PackedScene
@export var item_required: Node3D
@export var is_secondary = false

var is_puzzling = false
var is_done = false

func _ready() -> void:
	if not puzzle:
		print(name, " HAS NO PUZZLE SCENE TO TRIGGER, QUITTING TREE!")
		queue_free()
	elif not puzzle.instantiate() is GamePuzzle:
		print(name, " IS NOT ABLE TO TRIGGER PUZZLES, QUITTING TREE!")
		queue_free()

func _physics_process(_delta: float) -> void:
	if item_required:
		return
	
	self.puzzle_label.visible = \
		self.puzzle_area.is_there_collision and\
		not is_puzzling
	
	if puzzle_area.is_there_collision: #and not level_manager.player.UI_hud.is_using_ui():
		is_puzzling = false
	
	if self.puzzle_label.visible:
		if Input.is_action_just_pressed("game_interact"):
			#level_manager.startPuzzle(puzzle.instantiate(), object_to_react, self)
			is_puzzling = true
	
	if is_done:
		queue_free()
