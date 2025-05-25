extends Node3D

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		Global.load_level("res://scenes/level2.tscn", 2)
