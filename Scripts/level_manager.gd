class_name LevelManager
extends Node3D

signal ObjectBroken(obj: BaseLevelObject)
signal WonPuzzle(puzzleName: String)
signal LightsBroken()

var broken_objs = []
var enemies_chasing = []
var max_distance_to_obj: float = 8.0
var lights_level: Array = []
var lighs_on_the_level: Array = [] #Enemy class mentioned it, but it already exists
var npcList_parent_node3d: Array = []
var is_game_over = false

func emitBrokenObj(obj: BaseLevelObject):
	emit_signal("ObjectBroken", obj)
func emitLightsBroken():
	emit_signal("LightsBroken")
func emit_puzzle_won(puzzle_name: String):
	emit_signal("WonPuzzle", puzzle_name)

func _ready() -> void:
	connect("ObjectBroken", _addBrokenObj, CONNECT_DEFERRED)
	Global.connect("GameOver", react_game_over, CONNECT_DEFERRED)
	
	npcList_parent_node3d = get_tree().get_nodes_in_group("Enemies")
	#debug remove enemeis
	#for x in npcList_parent_node3d:
		#x.queue_free()

	#lighs_on_the_level = get_tree().get_nodes_in_group("Lights") #	Enemy reference already existed!!! 
	lights_level = get_tree().get_nodes_in_group("Lights")

func _addBrokenObj(brokenObj: BaseLevelObject):
	if broken_objs.has(brokenObj):
		return
	broken_objs.append(brokenObj)

func _physics_process(_delta: float) -> void:
	check_tasks()
	#if broken_objs.size():
		#assignClosestToFix()
	#checkLightNearPlayerIsVisible()

func check_tasks():
	var guards_roaming = []
	var guards_chasing = []
	var guards_fixing = []
	var guards_busting = []
	for guard in npcList_parent_node3d:
		guard = guard as Enemy
		if guard.state == Enemy.states.ROAMING:
			guards_roaming.append(guard)
		elif guard.state == Enemy.states.CHASING:
			guards_chasing.append(guard)
		elif guard.state == Enemy.states.FIXING:
			guards_fixing.append(guard)
		elif guard.state == Enemy.states.BUSTING:
			guards_busting.append(guard)

	$UiManager.change_chase_visible(not guards_chasing.is_empty())
	
	if not guards_busting.is_empty():
		$Audio.play_gameover()
	elif not guards_chasing.is_empty():
		$Audio.play_enemies_chasing()
	else:
		$Audio.play_level_track()
	
	# fix lights
	for broken_obj in broken_objs:
		broken_obj = broken_obj as BaseLevelObject
		if not broken_obj.is_broken:
			continue
		for guard in guards_roaming:
			guard = guard as Enemy
			if broken_obj.is_getting_fixed_by == guard:
				broken_obj.is_getting_fixed_by = null
			var distance = guard.global_position.distance_to(broken_obj.global_position)
			if distance <= max_distance_to_obj and not broken_obj.is_getting_fixed_by:
				DevTools.consoleText(guard.name, " | found at ", "%.1f" %distance, " meters | fixing ", broken_obj.name)
				broken_obj.is_getting_fixed_by = guard
				guard.to_fix_object_ai = broken_obj
				
	# toggle lantern


func pickedItem(item: Item):
	if item.obj_to_react and item.obj_to_react.has_method("react"):
		item.obj_to_react.react()
	$Audio/PickUpItem.play()

func addChase(enemy: Enemy):
	if enemies_chasing.has(enemy):
		return
	enemies_chasing.append(enemy)
func removeChase(enemy: Enemy):
	if enemies_chasing.has(enemy):
		var search = enemies_chasing.find(enemy)
		if search > -1:
			enemies_chasing.remove_at(search)

func react_game_over():
	is_game_over = true
	$Audio/GameOver.play()
