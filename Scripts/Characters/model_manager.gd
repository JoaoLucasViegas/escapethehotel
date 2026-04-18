class_name ModelManager extends Node3D

enum types {
	PLAYER, ENEMY, NULL
}
@export_category("Model")
@export var type: types = types.PLAYER
@export var animationPlayer: AnimationPlayer
@export var stop_bias = 0.0
@export var vector_movement = Vector3.ZERO

@export_category("Player")
@export var player_state: Player.states

@export_category("Enemy")
@export var enemy_state: Enemy.states

func _physics_process(_delta: float) -> void:
	if not animationPlayer:
		return
	if type == types.NULL:
		return
	if type == types.PLAYER:
		if player_state == Player.states.BUSTED:
			type = types.NULL
			animationPlayer.play("die")
			stop_bias = 0.5
			return
		elif player_state == Player.states.PUZZLING:
			animationPlayer.play("interact-right")
			return
	elif type == types.ENEMY:
		if enemy_state == Enemy.states.BUSTING:
			type = types.NULL
			stop_bias = 0.0
			animationPlayer.play("attack-melee-right")
			return
		elif enemy_state == Enemy.states.CHASING:
			animationPlayer.play("sprint")
			return
		elif enemy_state == Enemy.states.FIXING:
			animationPlayer.play("interact-left")
			stop_bias = 0.5
			return
	
	if self.vector_movement.length() <= stop_bias:
		animationPlayer.play("idle")
	elif self.vector_movement.length() > stop_bias:
		@warning_ignore("standalone_ternary")
		animationPlayer.play("sprint") if type == types.PLAYER else animationPlayer.play("walk")
