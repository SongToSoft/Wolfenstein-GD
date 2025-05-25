extends Area3D

func _on_body_entered(body):
	if body.is_in_group("player") and body.weapon_script.current_weapon != "machine":
		$AudioStreamPlayer.play()
		body.set_weapon("machine")

func _on_audio_stream_player_finished():
	queue_free()
