extends StaticBody3D

@onready var animation_player = $AnimationPlayer
@onready var area = $Area3D
@onready var collision = $CollisionShape3D

var is_open = false

func _input(event):
	if event.is_action_pressed("ui_focus_next") and not is_open:
		open_door()

func open_door():
	is_open = true
	collision.disabled = true
	animation_player.play("open")

func _on_area_3d_body_entered(body):
	if body.is_in_group("player"):
		body.set("can_open_door", true)
		print("Player in range of door")


func _on_area_3d_body_exited(body):
	if body.is_in_group("player"):
		body.set("can_open_door", false)
		print("Player left range of door")
