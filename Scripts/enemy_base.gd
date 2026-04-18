class_name Enemy
extends CharacterBody3D

@onready var catchPlayer_area = $CatchPlayer
@onready var linesight_area = $Pivot/LineOfSightArea
@onready var footsteps_area = $Pivot/FootStepsArea
@onready var waypoint_area = $Pivot/WayPointArea
@onready var model_manager = $Pivot/Model
#
@onready var raycast_sight = $RayCast3D
@onready var corridor_timer = $CheckCorridorTimer
@onready var fixBroken_timer = $FixBrokenTimer
@onready var nav_agent = $NavigationAgent3D
@onready var spotlight_ai = $Pivot/SpotLight3D

var player: Player = null
@export var path_ai: Path3D
@export var to_fix_object_ai: BaseLevelObject
@export var level_manager: LevelManager
#
@export var speed: float = 7.0
@export var timer_waypoint_ai: float = 1.0
@export var timer_fixBroken_ai: float = 3.0
@export var fixing_broken_multiplier_speed = 0.8

#debug
@onready var debug_label = $debugLabel

#var is_chasing = false
#var is_following = false
#var is_busting = false
#@export var is_fixing = false
enum states {
	ROAMING, CHASING, BUSTING, FIXING, NULL
}
var state = states.NULL


var waypoint_ai = Vector3.ZERO
var last_player_position_ai = Vector3.ZERO
var waypoint_idx = 0

func _ready() -> void:
	if not player:
		player = get_tree().get_nodes_in_group("Player").front()
		#print_debug("NO PLAYER SELECTED ON ITS INSTANCE")
		#queue_free()
	corridor_timer.wait_time = timer_waypoint_ai
	fixBroken_timer.wait_time = timer_fixBroken_ai
	model_manager.stop_bias = 0.0

func _physics_process(delta: float) -> void:
	debug_label.visible = DevTools.is_debugging
	$Pivot/WayPointArea/MeshInstance3D2.visible = DevTools.is_debugging
	debug_label.text = name

	#if catchPlayer_area.is_there_collision:
		#state = states.BUSTING
		#model_manager.enemy_is_busting = true
		#nav_agent.target_position = position
		#Global.emit_game_over()
		#pass


	if not is_on_floor():
		velocity += get_gravity() * delta

	if state == states.BUSTING:
		velocity = Vector3.ZERO
		model_manager.vector_movement = velocity
		set_collision_layer_value(3, false)
		move_and_slide()
		debug_label.text += str("\n BUSTING!")
		set_physics_process(false)
		return

	if footsteps_area.is_there_collision:
		raycast_sight.target_position = to_local(player.global_position)
		debug_label.text += str("\n Looking at ", raycast_sight.target_position)
	elif player.is_seen_by_light:
		if linesight_area.is_there_collision:
			raycast_sight.target_position = to_local(player.global_position)
			debug_label.text += str("\n Player at ", raycast_sight.target_position)
	else:
		raycast_sight.target_position = Vector3.ZERO

	if raycast_sight.get_collider() is Player:
		if state == states.BUSTING:
			set_collision_layer_value(3, false)
			model_manager.enemy_is_busting = true
			velocity = Vector3(0, velocity.y, 0).normalized()
			move_and_slide()
			return

		fixBroken_timer.stop()
		state = states.CHASING
		#is_following = false
		#is_chasing = true
		#is_fixing = false
		to_fix_object_ai = null
		var playerPos = player.global_position
		last_player_position_ai = playerPos
		nav_agent.target_position = playerPos
		#var direction = (playerPos - global_position).limit_length()
		var direction: Vector3 = (nav_agent.get_next_path_position() - global_position).limit_length()
		velocity = direction * speed
		var vector_look_at = Vector3(direction.x, 0, direction.z).normalized()
		if not global_position.is_equal_approx(position + vector_look_at):
			linesight_area.get_parent_node_3d().look_at(position + vector_look_at, Vector3.UP, true)
	if state == states.CHASING:# is_chasing:
		if $ChasingTimer.is_stopped():
			$ChasingTimer.start()
		state = states.CHASING
		#is_following = false
		#is_chasing = true
		#is_fixing = false
		to_fix_object_ai = null
		nav_agent.target_position = last_player_position_ai
		#var direction = (playerPos - global_position).limit_length()
		var direction: Vector3 = (nav_agent.get_next_path_position() - global_position).limit_length()
		velocity = direction * speed
		if velocity.length() <= speed - PI/2:
			#is_chasing = false
			state = states.ROAMING
			corridor_timer.start(0.0)

		var vector_look_at = Vector3(direction.x, 0, direction.z).normalized()
		if not global_position.is_equal_approx(position + vector_look_at):
			linesight_area.get_parent_node_3d().look_at(position + vector_look_at, Vector3.UP, true)
		debug_label.text += str("\n Chasing at ", last_player_position_ai)
	elif not to_fix_object_ai == null:
		if not to_fix_object_ai.is_getting_fixed_by == self:
			to_fix_object_ai = null
		#is_following = false
		#is_chasing = false
		#is_fixing = true
		state = states.FIXING
		var to_fix_position = to_fix_object_ai.global_position
		nav_agent.target_position = to_fix_position
		#var direction = (playerPos - global_position).limit_length()
		var direction: Vector3 = (nav_agent.get_next_path_position() - global_position).limit_length()
		velocity = direction * speed * fixing_broken_multiplier_speed
		if (nav_agent.target_position - global_position).length() <= 1.0:
			velocity = Vector3(0.01, velocity.y, 0.01)
			#model_manager.enemy_state = state
			#model_manager.enemy_is_fixing = is_fixing
			if fixBroken_timer.is_stopped():
				fixBroken_timer.start()
		if velocity.length() >= speed*fixing_broken_multiplier_speed - PI/2:
			var vector_look_at = Vector3(direction.x, 0, direction.z).normalized()
			if not global_position.is_equal_approx(position + vector_look_at):
				linesight_area.get_parent_node_3d().look_at(position + vector_look_at, Vector3.UP, true)
		debug_label.text += str("\n To Fix: ", to_fix_object_ai.name)
	else:
		#walk towards waypoint
		if state == states.NULL:
			state = states.ROAMING
			#is_following = true
			waypoint_ai = path_ai.position + path_ai.curve.get_point_position(waypoint_idx) #
		#var direction = (waypoint_ai - global_position).limit_length()
		nav_agent.target_position = waypoint_ai
		var direction: Vector3 = (nav_agent.get_next_path_position() - global_position).limit_length()
		if waypoint_area.is_there_collision and waypoint_area.overlapping_body_name == name:
			velocity = Vector3(0, velocity.y, 0)
			if corridor_timer.is_stopped():
				corridor_timer.start()
				waypoint_area.get_child(0).disabled = true
		else:
			velocity = direction * speed
		if velocity.length() >= speed - PI/2:
			var vector_look_at = Vector3(direction.x, 0, direction.z).normalized()
			if not global_position.is_equal_approx(position + vector_look_at):
				linesight_area.get_parent_node_3d().look_at(position + vector_look_at, Vector3.UP, true)
		waypoint_area.global_position = waypoint_ai

	model_manager.enemy_state = state#is_chasing
	if state == states.CHASING:# is_chasing:
		level_manager.addChase(self)
	else:
		level_manager.removeChase(self)

	move_and_slide()
	model_manager.vector_movement = velocity
	debug_label.text += str("\n STATE: ", str(states.find_key(state)))
	$Pivot/WayPointArea/MeshInstance3D2/debugLabel.text = str(name)
	#level_manager.checkLightsAreOn() #IT WASNT EVEN BEING USED... IT WAS DOING NOTHING

func _on_check_corridor_timer_timeout() -> void:
	if waypoint_idx + 1 >= path_ai.curve.point_count: waypoint_idx = 0
	else: waypoint_idx += 1
	#is_following = false
	state = states.NULL
	waypoint_area.get_child(0).disabled = false

func _on_fix_broken_timer_timeout() -> void:
	to_fix_object_ai.is_broken = false
	to_fix_object_ai.is_getting_fixed_by = null
	to_fix_object_ai = null
	#is_fixing = false
	state = states.NULL
	model_manager.enemy_state = state
	#model_manager.enemy_is_fixing = is_fixing

func _on_chasing_timer_timeout() -> void:
	#is_chasing = false
	state = states.ROAMING
