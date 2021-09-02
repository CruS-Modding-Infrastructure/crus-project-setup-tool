extends MarginContainer
var enemy_value = 0
var civ_value = 0
var active = false
var time = 0
var init_timer = 0

func _physics_process(delta):
	time += 1
	if Input.is_action_just_pressed("debug_finish_level") and Global.debug:
		Global.level_finished()
	if active and fmod(time, 3) == 0:
		if init_timer < 10:
			init_timer += 1
		elif enemy_value < Global.enemy_count_total - Global.enemy_count:
			enemy_value += 1
			$HBoxContainer / VBoxContainer / Level_End_Info / Enemy_HBOX / Enemies_Value.text = str(enemy_value, "/", Global.enemy_count_total)
			var color = float(enemy_value) / float(Global.enemy_count_total)
			$HBoxContainer / VBoxContainer / Level_End_Info / Enemy_HBOX / Enemies_Value.add_color_override("font_color", Color(1 - color, color, 0))
		elif civ_value < Global.civ_count_total - Global.civ_count:
			civ_value += 1
			var color = float(civ_value) / float(Global.civ_count_total)
			$HBoxContainer / VBoxContainer / Level_End_Info / Civ_HBOX2 / Civ_Value.add_color_override("font_color", Color(1 - color, color, 0))
			$HBoxContainer / VBoxContainer / Level_End_Info / Civ_HBOX2 / Civ_Value.text = str(civ_value, "/", Global.civ_count_total)
		else :
			active = false
			enemy_value = 0
			civ_value = 0
			$HBoxContainer / VBoxContainer / VBoxContainer.show()
