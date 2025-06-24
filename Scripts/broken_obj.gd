class_name BaseLevelObject
extends Node3D

@onready var sabotage_area = $AreaSight
@onready var sabotage_label = $Label3D

@export var level_manager: LevelManager
@export var obj_to_react: Node3D

@export var is_broken = false
var called_to_fix = false
var is_getting_fixed_by: Enemy

func _ready() -> void:
	if not level_manager:
		print(name, " HAS NO LEVEL MANAGER ATTACHED TO CONTINUE EXISTING")
		queue_free()

func _physics_process(delta: float) -> void:
	$Switch.volume_db = move_toward($Switch.volume_db, -9.2, 10 * delta)
	
	if is_broken and not called_to_fix:
		self.called_to_fix = true
		self.level_manager.emitBrokenObj(self)
		$Switch.play()
	
	if not is_broken:
		self.called_to_fix = false
	if obj_to_react:
		self.obj_to_react.visible = not is_broken
	if is_getting_fixed_by:
		if not is_getting_fixed_by.to_fix_object_ai == self:
			is_getting_fixed_by = null
	
	self.sabotage_label.visible = \
		self.sabotage_area.is_there_collision and \
		not self.is_broken and \
		not level_manager.player.is_using_ui
	
	if not self.is_broken and self.sabotage_label.visible:
		if Input.is_action_just_pressed("game_interact"):
			self.level_manager.showSabotageScreen(self)
