extends Area3D

const AMMO_VALUE = 10

func _on_body_entered(body):
	if body.is_in_group("player"):
		$AudioStreamPlayer.play()
		body.add_ammo(AMMO_VALUE)


func _on_audio_stream_player_finished():
	queue_free()
