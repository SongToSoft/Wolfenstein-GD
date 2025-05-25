extends CharacterBody3D

@onready var audio_player = $AudioStreamPlayer3D

const SPEED = 5.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var dead = false
var is_attacking = false
var attack_range = 5
var attack_damage = 5
var health = 100

func _ready():
	audio_player.stream = preload("res://sounds/gun.ogg")
	add_to_group("enemy")
	
func _physics_process(delta):
	if dead or is_attacking:
		return
	
	if Global.player == null:
		return

	var distance_to_player = global_position.distance_to(Global.player.global_position)
	if distance_to_player > attack_range:
		var direction =  Global.player.global_position - global_position
		direction.y = 0.0
		direction = direction.normalized()
		
		velocity = direction * SPEED

		if not is_on_floor():
			velocity.y -= gravity + delta
		
		$AnimatedSprite3D.play("walk")
		move_and_slide()
	else:
		attack()

func attack():
	var direction = Global.player.global_position - global_position
	direction.y = 0.0
	direction = direction.normalized()
	rotation.y = atan2(direction.x, direction.z)

	is_attacking = true
	audio_player.play()
	$AnimatedSprite3D.play("shoot")

	if $RayCast3D.is_colliding() and $RayCast3D.get_collider().has_method("take_damage"):
		$RayCast3D.get_collider().take_damage(attack_damage)

	await $AnimatedSprite3D.animation_finished
	is_attacking = false

func take_damage(damage):
	health -= damage
	if health <= 0:
		die()

func die():
	dead = true;
	if (Global.player):
		Global.player.add_score(100)

	$AnimatedSprite3D.play("die")
	$CollisionShape3D.disabled = true
	
	audio_player.stream = preload("res://sounds/Enemy Pain.wav")
	audio_player.play()
