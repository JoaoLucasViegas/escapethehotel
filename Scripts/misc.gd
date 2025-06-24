extends Node

@export var cloud_noise: FastNoiseLite
@export var cloud_mov_speed: float = 1.0

func _ready() -> void:
	if not cloud_noise:
		cloud_noise = FastNoiseLite.new()

func _physics_process(delta: float) -> void:
	cloud_noise.offset.x += cloud_mov_speed * delta
