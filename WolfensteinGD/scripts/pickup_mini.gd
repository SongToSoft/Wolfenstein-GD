extends Area3D

func _on_body_entered(body):
	if body.is_in_group("player") and body.weapon_script.current_weapon != "mini":
		$AudioStreamPlayer.play()
		body.set_weapon("mini")

func _on_audio_stream_player_finished():
	queue_free()
