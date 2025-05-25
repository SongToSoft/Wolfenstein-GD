extends CanvasLayer

var weapon_textures = {
	"gun": preload("res://sprites/hudgun.png"),
	"machine": preload("res://sprites/hudmachinegun.png"),
	"mini": preload("res://sprites/hudmini.png"),
	"knife": preload("res://sprites/hudknife.png"),
}
	
func init(player, weapon):
	update_level_label(Global.level_number)

	if player == null or weapon == null:
		return

	update_score_label(player.score)
	update_health_label(player.health)
	update_lives_label(player.lives)
	update_face_animation(player.health)
	update_ammo_label(weapon.ammo)
	set_weapon_icon(weapon.current_weapon)

func set_weapon_icon(weapon):
	if $WeaponIcon.texture != weapon_textures[weapon]:
		$WeaponIcon.texture = weapon_textures[weapon]

func update_health_label(health):
	$HealthValue.text=str(health) + '%'
	
func update_ammo_label(ammo):
	$AmmoValue.text=str(ammo)
	
func update_lives_label(lives):
	$LivesValue.text=str(lives)

func update_level_label(level):
	$LevelValue.text=str(level)
	
func update_score_label(score):
	$ScoreValue.text=str(score)

func update_face_animation(health):
	var animation_name = ""
	if health > 90:
		animation_name = "100"
	elif health > 75:
		animation_name = "90"
	elif health > 60:
		animation_name = "75"
	elif health > 45:
		animation_name = "60"
	elif health > 30:
		animation_name = "45"
	elif health > 15:
		animation_name = "30"
	else:
		animation_name = "15"

	$face.play(animation_name)
