extends Node

var level_number = 1
var player = null

func load_level(level_path, new_level_number):
	self.level_number = new_level_number
	if self.player:
		self.player.ui_script.update_level_label(self.level_number)
	call_deferred("change_scene", level_path)

func change_scene(level_path):
	get_tree().change_scene_to_file(level_path)
