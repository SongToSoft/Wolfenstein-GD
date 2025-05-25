extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const TURN_SPEED = 0.05
const MAX_HEALTH = 150

@onready var ui_script = $ui
@onready var ray = $Camera3D/RayCast3D
@onready var weapon_script = $weapon

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var can_open_door = false
var score = 0;
var health = 100;
var lives = 3;

func _ready():
	Global.player = self
	ui_script.init(self, weapon_script)
		
	add_to_group("player")
	set_weapon(weapon_script.last_weapon)

func _physics_process(delta):
	weapon_script.time_since_last_shot += delta
	weapon_script.can_shoot = weapon_script.time_since_last_shot >= (1.0 / weapon_script.fire_rate)

	if not is_on_floor():
		velocity.y -= gravity * delta

	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("input_left", "input_right", "input_up", "input_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	camera_rotate()

	if Input.is_action_pressed("ui_accept") and weapon_script.can_shoot:
		shoot()

	move_and_slide()

func take_damage(damage):
	self.health -= damage
	if self.health <= 0:
		if self.lives <= 1:
			queue_free()
		else:
			self.lives -= 1
			health = 100
			set_weapon("gun")
			weapon_script.ammo = 10
			get_tree().change_scene_to_file("res://scenes/level1.tscn")
			ui_script.update_lives_label(self.lives)
	ui_script.update_health_label(self.health)
	ui_script.update_face_animation(self.health)

func heal(value):
	self.health = min(self.health + value, MAX_HEALTH)
	ui_script.update_health_label(self.health);
	ui_script.update_face_animation(self.health)

func camera_rotate():
	if Input.is_action_pressed("input_left"):
		self.rotate_y(TURN_SPEED)
	if Input.is_action_pressed("input_right"):
		self.rotate_y(-TURN_SPEED)

func shoot():
	weapon_script.shoot(global_position, ray)
	ui_script.update_ammo_label(weapon_script.ammo)
	if weapon_script.current_weapon != "knife" and weapon_script.ammo <= 0:
		set_weapon("knife")

func set_weapon(weapon):
	if weapon_script.is_can_set_weapon(weapon):
		ui_script.set_weapon_icon(weapon)
	weapon_script.set_weapon(weapon)


func add_ammo(ammo):
	weapon_script.ammo += 10
	set_weapon(weapon_script.last_weapon)
	ui_script.update_ammo_label(weapon_script.ammo)
	
func add_score(scoreValue):
	self.score += scoreValue
	ui_script.update_score_label(self.score)
