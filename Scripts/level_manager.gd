class_name LevelManager
extends Node3D

signal ObjectBroken(obj: BaseLevelObject)
signal WonPuzzle(puzzleName: String)
signal LightsBroken()

@onready var sabotage_ui = $Player/UI/SabotageScreen
@onready var puzzle_screen = $Player/UI/Puzzle
@onready var item_ui = $Player/UI/Items

@export var player: Player

var broken_objs = []
var enemies_chasing = []
var max_distance_to_obj: float = 8.0
var lights_level: Array
var npcList_parent_node3d: Array
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
	lights_level = get_tree().get_nodes_in_group("Lights")

func _addBrokenObj(brokenObj: BaseLevelObject):
	if broken_objs.has(brokenObj):
		return
	broken_objs.append(brokenObj)

func _physics_process(_delta: float) -> void:
	if broken_objs.size() > 0:
		var idx_to_remove = []
		var idx_broken = 0
		for broken in broken_objs:
			broken = broken as BaseLevelObject
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
	checkLightNearPlayerIsVisible()
	
	if is_game_over:
		$Audio/GameLoop.volume_db = move_toward($Audio/GameLoop.volume_db, -64, 0.3 * 12)
		$Audio/Chasing.volume_db = move_toward($Audio/Chasing.volume_db, -80, 2.0 * 12)
		$Audio/GameOver.volume_db = move_toward($Audio/GameOver.volume_db, -6.2, 0.3 * 12)
	elif enemies_chasing:
		if not $Audio/Chasing.playing:
			$Audio/Chasing.play()
		$Audio/GameLoop.volume_db = move_toward($Audio/GameLoop.volume_db, -32, 0.3 * 12)
		$Audio/Chasing.volume_db = move_toward($Audio/Chasing.volume_db, -12.2, 0.5 * 12)
	else:
		$Audio/GameLoop.volume_db = move_toward($Audio/GameLoop.volume_db, -16.2, 0.035 * 12)
		
		if not $Audio/Chasing.volume_db > -80:
			$Audio/Chasing.volume_db = move_toward($Audio/Chasing.volume_db, -80, 0.035 * 12)
		else:
			$Audio/Chasing.stop()
		

func _assignClosestToFix(brokenObj: BaseLevelObject):
	if not npcList_parent_node3d:
		return
	var idx: int = 0
	var npc_idx: int = -1
	var distance: float = max_distance_to_obj
	for npc in npcList_parent_node3d:
		npc = npc as Enemy
		var npc_distance_to = npc.global_position.distance_to(brokenObj.global_position)
		if npc_distance_to <= distance and not npc.to_fix_object_ai and not npc.is_chasing:
			distance = npc_distance_to
			npc_idx = idx
		idx += 1
	if distance >= max_distance_to_obj:
		return
	var selected_npc: Enemy = npcList_parent_node3d[npc_idx] as Enemy
	#print(selected_npc.name, " | found at ", distance, " meters | fixing ",brokenObj.name)
	if selected_npc.is_fixing:
		return
	if selected_npc.is_chasing:
		return
	if brokenObj.is_getting_fixed_by == selected_npc:
		return
	else:
		brokenObj.is_getting_fixed_by = selected_npc
		selected_npc.to_fix_object_ai = brokenObj

func checkLightNearPlayerIsVisible():
	if not lights_level:
		print("LEVEL MANAGER HAS NO LIGHTS TO ATTACH TASKS")
		return
	var closest_light: Node3D = null
	var closest_distance_to_player = 8
	for light in lights_level:
		if not light:
			continue
		var light_loop = light as Node3D
		var distance = light_loop.global_position.distance_to(global_position)
		if distance <= closest_distance_to_player:
			closest_distance_to_player = distance
			closest_light = light_loop
	if closest_light:
		player.is_seen_by_light = closest_light.is_visible_in_tree()
	else:
		player.is_seen_by_light = false
	#print(closest_light, "| is close to player at distance ", closest_distance_to_player)

func startPuzzle(puzzle: GamePuzzle, obj: Node3D, caller: PuzzleCaller):
	puzzle_screen.addPuzzle(puzzle, obj, caller)

func showSabotageScreen(obj: BaseLevelObject):
	sabotage_ui.sabotage(obj)

func pickedItem(item: Item):
	item_ui.new_item(item)
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
