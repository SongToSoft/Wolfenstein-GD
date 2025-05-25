extends Area3D

const HEAL_VALUE = 25

func _on_body_entered(body):
	if body.is_in_group("player") and body.has_method("heal"):
		$AudioStreamPlayer.play()
		body.heal(HEAL_VALUE); 
		set_deferred("monitoring", false)

func _on_audio_stream_player_finished():
	queue_free()
