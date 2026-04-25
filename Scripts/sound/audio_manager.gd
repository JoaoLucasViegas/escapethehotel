class_name GameAudioManager extends Node

func play_gameover():
	$GameLoop.volume_db = move_toward($GameLoop.volume_db, -64, 0.3 * 12)
	$Chasing.volume_db = move_toward($Chasing.volume_db, -80, 2.0 * 12)
	$GameOver.volume_db = move_toward($GameOver.volume_db, -6.2, 0.3 * 12)
func play_enemies_chasing():
	if not $Chasing.playing:
		$Chasing.play()
	$GameLoop.volume_db = move_toward($GameLoop.volume_db, -32, 0.3 * 12)
	$Chasing.volume_db = move_toward($Chasing.volume_db, -12.2, 0.5 * 12)
func play_level_track():
		$GameLoop.volume_db = move_toward($GameLoop.volume_db, -16.2, 0.035 * 12)
		if not $Chasing.volume_db > -80:
			$Chasing.volume_db = move_toward($Chasing.volume_db, -80, 0.035 * 12)
		else:
			$Chasing.stop()
