class_name Player
extends CharacterBody3D

@onready var pivot = $Pivot
@onready var model_manager = $Pivot/Model

const SPEED = 9.0
const JUMP_VELOCITY = 4.5

var is_seen_by_light = false
var is_using_ui = false
var is_busted = false

func _physics_process(delta: float) -> void:
	
	if is_busted:
		set_collision_layer_value(2, false)
		velocity = Vector3(0, 0, 0).normalized()
		model_manager.player_is_busted = true
		move_and_slide()
		walkStop()
		$CameraOrbit/Camera3D.fov = move_toward($CameraOrbit/Camera3D.fov, 80, SPEED * 0.15 * delta)
		$CameraOrbit/Camera3D.position.z = move_toward($CameraOrbit/Camera3D.position.z, 3, SPEED * 0.3 * delta)
		
		$CameraOrbit.rotation_degrees.y -= SPEED * 1.5 * delta
		#$CameraOrbit/Camera3D.look_at($Pivot.global_position, Vector3.UP, true)
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += get_gravity().y * 2 * delta
	
	# Handle jump.
	if is_on_floor():
		if Input.is_action_just_pressed("ui_accept") and not is_using_ui:
			velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_l", "move_r", "move_u", "move_d", 0.5).rotated(-$CameraOrbit.rotation.y)
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		walkSteps()
		$Feet.pitch_scale = randf_range(0.9, 1.1)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		walkStop()
	is_using_ui = \
		$UI/SabotageScreen.visible \
		or $UI/Puzzle.visible
	if is_using_ui:
		velocity = Vector3(0, velocity.y, 0).normalized()
		if Input.is_action_just_pressed("ui_cancel"):
			$UI.clearHUD()
			is_using_ui = !is_using_ui
	model_manager.player_is_puzzling = is_using_ui
	
	var vector_look_at = Vector3.ZERO.slerp(Vector3(direction.x, 0, direction.z).normalized()/2, .001)
	if not global_position.is_equal_approx(position + vector_look_at):
		pivot.look_at(position + vector_look_at, Vector3.UP, true)

	move_and_slide()
	
	model_manager.vector_movement = velocity

func walkSteps():
	if $Feet.playing:
		return
	$Feet.pitch_scale = randf_range(0.9, 1.1)
	$Feet.play()
	$Pivot/Particle.emitting = true
func walkStop():
	$Feet.stop()
	$Pivot/Particle.emitting = false
