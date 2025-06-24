extends Node3D

@export var vector_movement = Vector3.ZERO
@export var stop_bias = 0.0

@export var type: String = ""

@export_category("Player")
@export var player_is_busted = false
@export var player_is_puzzling = false

@export_category("Enemy")
@export var enemy_is_fixing = false
@export var enemy_is_chasing = false
@export var enemy_is_busting = false

@export var animationPlayer: AnimationPlayer

func _physics_process(_delta: float) -> void:
	if not animationPlayer:
		return
	
	if type == "Player":
		if player_is_busted:
			type = ""
			animationPlayer.play("die")
			stop_bias = 0.5
			return
		elif player_is_puzzling:
			animationPlayer.play("interact-right")
			return
	elif type == "Enemy":
		if enemy_is_busting:
			type = ""
			stop_bias = 0.0
			animationPlayer.play("attack-melee-right")
			return
		elif enemy_is_chasing:
			animationPlayer.play("sprint")
			return
		elif enemy_is_fixing:
			animationPlayer.play("interact-left")
			stop_bias = 0.5
			return
	elif not type.length():
		return
	
	if self.vector_movement.length() <= stop_bias:
		animationPlayer.play("idle")
	elif self.vector_movement.length() > stop_bias:
		if type == "Player": animationPlayer.play("sprint")
		else:animationPlayer.play("walk")
