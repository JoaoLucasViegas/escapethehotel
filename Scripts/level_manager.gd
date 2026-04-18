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
	if not broken_objs.is_empty():
		var idx_to_remove = []
		var idx_broken = 0
		for broken in broken_objs:
			#broken = broken as BaseLevelObject
			if not broken.is_broken:
				idx_to_remove.append(idx_broken)
			elif broken.is_getting_fixed_by:
				idx_broken += 1
				continue
			else:
				_assignClosestToFix(broken)
			idx_broken += 1
		for idx in idx_to_remove:
			broken_objs.remove_at(idx)
	#checkLightNearPlayerIsVisible()

func _assignClosestToFix(brokenObj: BaseLevelObject):
	if not npcList_parent_node3d:
		return
	var idx: int = 0
	var npc_idx: int = -1
	var distance: float = max_distance_to_obj
	for npc in npcList_parent_node3d:
		#if not npc or npc.is_queued_for_deletion(): #So Enemies were supposed to die?!? -- IDK (dont remember)
			#continue
		#npc = npc as Enemy
		var npc_distance_to = npc.global_position.distance_to(brokenObj.global_position)
		if npc_distance_to <= distance and not npc.to_fix_object_ai and not npc.state == Enemy.states.CHASING:#is_chasing:
			distance = npc_distance_to
			npc_idx = idx
		idx += 1
	if distance >= max_distance_to_obj:
		return
	var selected_npc: Enemy = npcList_parent_node3d[npc_idx] as Enemy
	#print(selected_npc.name, " | found at ", distance, " meters | fixing ",brokenObj.name)
	DevTools.consoleText(selected_npc.name, " | found at ", "%.1f" %distance, " meters | fixing ",brokenObj.name)
	if brokenObj.is_getting_fixed_by == selected_npc:
		return
	#if selected_npc.is_fixing:
		#return
	#if selected_npc.is_chasing:
		#return
		#return
	#if selected_npc.state == Enemy.states.ROAMING:
	else:
		brokenObj.is_getting_fixed_by = selected_npc
		selected_npc.to_fix_object_ai = brokenObj

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
