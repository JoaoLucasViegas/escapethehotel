class_name Player
extends CharacterBody3D

@onready var pivot = $Pivot
@onready var model_manager = $Pivot/Model

@onready var camera_3d = get_viewport().get_camera_3d()
@onready var camera_orbit = $CameraOrbit

@onready var feet_sfx = $Feet
@onready var feet_particle = $Particle

#@export var UI_hud: UIManager

#debug
@onready var debug_label = $debugLabel

const SPEED = 7.086
const JUMP_VELOCITY = 4.5

enum states {
	FREE, BUSTED, PUZZLING, NULL
}
var state: states = states.FREE

var is_seen_by_light = false
var stamina_booster: float = 100.0

func _ready() -> void:
	Global.connect("GameOver", _busted)

func _physics_process(delta: float) -> void:
	debug_label.visible = DevTools.is_debugging
	debug_label.text = name
	
	#debug_label.text += str("\n POS: ", global_position)
	#debug_label.text += str("\n IS SEEN BY LIGHT: ", is_seen_by_light)
	#debug_label.text += str("\n IS BUSTED: ", is_busted)
	
	if state == states.BUSTED:# is_busted:
		set_collision_layer_value(2, false)
		velocity = Vector3(0, 0, 0).normalized()
		model_manager.player_state = state# = true
		move_and_slide()
		walkStop()
		camera_3d.fov = move_toward(camera_3d.fov, 80, delta * 115 * delta)
		camera_3d.position.z = move_toward(camera_3d.position.z, 3, delta * 115 * delta)
		
		camera_3d.get_parent_node_3d().rotation_degrees.y -= 8.6 * 2.0 * delta #camera_orbit
		#set_physics_process(false)
		#camera_3d.look_at($Pivot.global_position, Vector3.UP, true)
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity().y * 2 * delta
	
	$ProgressBar.value = stamina_booster

	# Get the input direction and handle the movement/desaceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_l", "move_r", "move_u", "move_d", 0.5)#.rotated(-camera_orbit.rotation.y)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		walkSteps()
		feet_sfx.pitch_scale = randf_range(0.9, 1.1)
		velocity.x = lerpf(velocity.x, direction.x * SPEED, ease(1, .5))
		velocity.z = lerpf(velocity.z, direction.z * SPEED, ease(1, .5))
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		walkStop()
	
	if is_on_floor():
		#Acitvate booster:
		if Input.is_action_pressed("move_boost"):
			if velocity != Vector3.ZERO:# and not UI_hud.is_using_ui():
			#velocity.y = JUMP_VELOCITY
				stamina_booster -= delta * (1+stamina_booster*20/100)
				velocity = velocity * (1+(stamina_booster*.86/100))
		#	feet_particle.amount = 8
		elif not Input.is_action_pressed("move_boost"):
			if stamina_booster <= 100:
				stamina_booster += ((1430.0/100.0)+stamina_booster/100.0) * delta
				stamina_booster = clampf(stamina_booster, 0, 100)
		#	feet_particle.amount = 4
	
	#if UI_hud.is_using_ui():
		#state = states.PUZZLING
		#velocity = Vector3(0, velocity.y, 0).normalized()
		#if Input.is_action_just_pressed("ui_cancel"):
			#UI_hud.clearHUD()
			#UI_hud.disable_ui_gameplay()
	
	var vector_look_at = Vector3.ZERO.slerp(Vector3(direction.x, 0, direction.z).normalized()/2, 1.0)
	if not global_position.is_equal_approx(position + vector_look_at):
		pivot.look_at(
			lerp(pivot.global_position, position + vector_look_at, 0.86),
			Vector3.UP, true)
	
	move_and_slide()
	
	model_manager.vector_movement = velocity
	model_manager.player_state = state

func _busted():
	state = states.BUSTED
	$TextureRect.hide()
	$ProgressBar.hide()

func walkSteps():
	if feet_sfx.playing:
		return
	feet_sfx.pitch_scale = randf_range(0.9, 1.1)
	feet_sfx.play()
	feet_particle.emitting = true
func walkStop():
	feet_sfx.stop()
	feet_particle.emitting = false
