extends CanvasLayer

@onready var player_sound = $AudioStreamPlayer3D

const DEFAULT_WEAPON = "gun"
const KNIFE_RANGE = 3

var current_weapon = DEFAULT_WEAPON
var last_weapon = DEFAULT_WEAPON

var fire_rate = 1.0
var ammo = 10

var time_since_last_shot = 0.0
var can_shoot = true

func _ready():
	$WeaponSprite2D.animation_finished.connect(_on_AnimatedSprite2D_animation_finished)

func _on_AnimatedSprite2D_animation_finished():
	$WeaponSprite2D.play(self.current_weapon  + "_idle")

func _process(_delta):
	if Input.is_action_pressed("ui_select") and self.can_shoot:
		if self.current_weapon == "knife":
			$WeaponSprite2D.play("stab")
		else:
			$WeaponSprite2D.play(self.current_weapon + "_shoot")

func set_weapon(weapon):
	if (weapon != "knife"):
		self.last_weapon = weapon
	if (is_can_set_weapon(weapon)):
		self.current_weapon = weapon
		$WeaponSprite2D.play(self.current_weapon + "_idle")
		update_fire_rate()

func is_can_set_weapon(weapon):
	return self.ammo != 0 || weapon == "knife"

func update_fire_rate():
	match self.current_weapon:
		"gun":
			self.fire_rate = 2.0
		"machine":
			self.fire_rate = 6.0
		"mini":
			self.fire_rate = 10.0
		"knife":
			self.fire_rate = 1.0
		_:
			self.fire_rate = 1.0

func get_weapon_damage():
	match self.current_weapon:
		"knife":
			return 100
		"gun":
			return 50
		"machine":
			return 50
		"mini":
			return 50
		_:
			return 0

func shoot(playerPosition, ray):
	self.time_since_last_shot = 0.0

	match self.current_weapon:
		"knife":
			player_sound.stream = preload("res://sounds/Knife.wav")		
		"gun":
			player_sound.stream = preload("res://sounds/gun.ogg")
		"machine":
			player_sound.stream = preload("res://sounds/machine.ogg")
		"mini":
			player_sound.stream = preload("res://sounds/mini.ogg")
	
	player_sound.play()
	
	if ray.is_colliding():
		var collider = ray.get_collider()
		var distance_to_collider = playerPosition.distance_to(collider.global_position)
	
		if self.current_weapon == "knife" and distance_to_collider > KNIFE_RANGE:
			return
		else:
			if collider.has_method("take_damage"):
				ray.get_collider().take_damage(get_weapon_damage())
	
	if self.current_weapon != "knife":
		if self.ammo > 0:
			self.ammo -= 1
