class_name GameAudioManager extends Node

func play_gameover():
	$Audio/GameLoop.volume_db = move_toward($Audio/GameLoop.volume_db, -64, 0.3 * 12)
	$Audio/Chasing.volume_db = move_toward($Audio/Chasing.volume_db, -80, 2.0 * 12)
	$Audio/GameOver.volume_db = move_toward($Audio/GameOver.volume_db, -6.2, 0.3 * 12)
func play_enemies_chasing():
	if not $Audio/Chasing.playing:
		$Audio/Chasing.play()
	$Audio/GameLoop.volume_db = move_toward($Audio/GameLoop.volume_db, -32, 0.3 * 12)
	$Audio/Chasing.volume_db = move_toward($Audio/Chasing.volume_db, -12.2, 0.5 * 12)
func play_level_track():
		$Audio/GameLoop.volume_db = move_toward($Audio/GameLoop.volume_db, -16.2, 0.035 * 12)
		if not $Audio/Chasing.volume_db > -80:
			$Audio/Chasing.volume_db = move_toward($Audio/Chasing.volume_db, -80, 0.035 * 12)
		else:
			$Audio/Chasing.stop()
