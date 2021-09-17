extends Spatial

export  var level_index = 13
export  var level_name = "Darkworld"

func _ready():
	var new_mat = $level_painting / Cube.mesh.surface_get_material(1).duplicate()
	new_mat.albedo_texture = Global.LEVEL_IMAGES[level_index]
	$level_painting / Cube.set_surface_material(1, new_mat)

func _on_Area_body_entered(body):
	if body == Global.player:
		if Global.BONUS_UNLOCK.find(level_name) == - 1:
			Global.BONUS_UNLOCK.append(level_name)
		Global.objectives = 0
		Global.objective_complete = false
		Global.civ_count = 0
		Global.enemy_count = 0
		Global.enemy_count_total = 0
		Global.civ_count_total = 0
		Global.save_game()
		Global.CURRENT_LEVEL = level_index
		Global.music.stream = Global.LEVEL_SONGS[level_index]
		Global.goto_scene(Global.LEVELS[level_index])
