extends "res://Menu/Settings_Grid.gd"
var enemy_value = 0
var civ_value = 0
var active = false
var time = 0
var init_timer = 0

func _ready():
	rect_size.y = 0

func convert_time(old:int, new:int):
	var elapsed = (old - new) / 1000
	var elapsed_msecs = abs(old - new)
	var minutes = int(abs(elapsed)) / 60
	var seconds = int(abs(elapsed)) % 60
	var milseconds = int(abs(elapsed_msecs)) % 1000
	return str(minutes, ".", seconds, ".", milseconds)

func set_performance_info():
	if not Global.player.dead:
		$Level_Info_Vbox / Next_Level.show()
		$Level_Info_Vbox / Level_Select.hide()
		$Performance_Hbox / Performance_Scroll / RichTextLabel.text = ""
		if Global.punishment_mode:
			$Performance_Hbox / Performance_Scroll / RichTextLabel.text += "PUNISHMENT RECEIVED.\n"
		$Performance_Hbox / Performance_Scroll / RichTextLabel.text += str("Enemies killed: ", Global.enemy_count_total - Global.enemy_count, "/", Global.enemy_count_total, "\n")
		$Performance_Hbox / Performance_Scroll / RichTextLabel.text += str("Civilians lost: ", Global.civ_count_total - Global.civ_count, "/", Global.civ_count_total, "\n")
		if not Global.punishment_mode:
			$Performance_Hbox / Performance_Scroll / RichTextLabel.text += str("Mission reward: $", Global.LEVEL_REWARDS[Global.CURRENT_LEVEL], "\n")
		else :
			$Performance_Hbox / Performance_Scroll / RichTextLabel.text += str("Mission reward: $", Global.LEVEL_REWARDS[Global.CURRENT_LEVEL] * 2, "\n")

		$Performance_Hbox / VBoxContainer / Objective_Panel / Objectives.text = str("TIME", "\n", Global.level_time)
		if Global.stock_mode and not Global.hope_discarded:
			if Global.level_time_raw < Global.LEVEL_SRANK_S[Global.CURRENT_LEVEL]:
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/S.png")
			elif Global.level_time_raw < Global.LEVEL_RANK_A[Global.CURRENT_LEVEL]:
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/A.png")
			elif Global.level_time_raw < Global.LEVEL_RANK_B[Global.CURRENT_LEVEL]:
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/B.png")
			else :
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/C.png")
		elif not Global.hope_discarded:
			if Global.level_time_raw < Global.LEVEL_RANK_S[Global.CURRENT_LEVEL]:
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/S.png")
			elif Global.level_time_raw < Global.LEVEL_RANK_A[Global.CURRENT_LEVEL]:
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/A.png")
			elif Global.level_time_raw < Global.LEVEL_RANK_B[Global.CURRENT_LEVEL]:
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/B.png")
			else :
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/C.png")
		elif Global.stock_mode and Global.hope_discarded:
			if Global.level_time_raw < Global.HELL_SRANK_S[Global.CURRENT_LEVEL]:
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/S.png")
			elif Global.level_time_raw < Global.HELL_RANK_A[Global.CURRENT_LEVEL]:
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/A.png")
			elif Global.level_time_raw < Global.HELL_RANK_B[Global.CURRENT_LEVEL]:
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/B.png")
			else :
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/C.png")
		elif Global.hope_discarded:
			if Global.level_time_raw < Global.HELL_RANK_S[Global.CURRENT_LEVEL]:
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/S.png")
			elif Global.level_time_raw < Global.HELL_RANK_A[Global.CURRENT_LEVEL]:
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/A.png")
			elif Global.level_time_raw < Global.HELL_RANK_B[Global.CURRENT_LEVEL]:
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/B.png")
			else :
				$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/rank_letters/C.png")
	else :
		$Level_Info_Vbox / Next_Level.hide()
		$Level_Info_Vbox / Level_Select.show()
		$Performance_Hbox / Performance_Scroll / RichTextLabel.text = ""
		if Global.consecutive_deaths == 4 and Global.husk_mode:
			$Performance_Hbox / Performance_Scroll / RichTextLabel.text += "Due to your wasting of company resources by hogging the genetic recombinator, you've been selected to participate in an experimental biological enhancement program. All your debt is cleared and from now on your body will regenerate by itself. Can't say I envy you though.\n\n"
		$Performance_Hbox / Performance_Scroll / RichTextLabel.text += str("Enemies killed: ", Global.enemy_count_total - Global.enemy_count, "/", Global.enemy_count_total, "\n")
		$Performance_Hbox / Performance_Scroll / RichTextLabel.text += str("Civilians lost: ", Global.civ_count_total - Global.civ_count, "/", Global.civ_count_total, "\n")

		if Global.husk_mode:
			$Performance_Hbox / Performance_Scroll / RichTextLabel.text += "Feelings: Dulled\n"
			$Performance_Hbox / Performance_Scroll / RichTextLabel.text += str("Regeneration: $0\n")
		else :
			$Performance_Hbox / Performance_Scroll / RichTextLabel.text += str("Body reconstruction: -$", 500, "\n")
		$Performance_Hbox / VBoxContainer / Objective_Panel / Objectives.text = str("FAILURE")
		$Performance_Hbox / VBoxContainer / Portrait.texture = load("res://Textures/abraxas/face6.png")
func _physics_process(delta):
	time += 1
	
	if Input.is_action_just_pressed("debug_finish_level") and Global.debug:
		Global.level_finished()
	if active and fmod(time, 3) == 0:
		if init_timer < 10:
			init_timer += 1
		elif enemy_value < Global.enemy_count_total - Global.enemy_count:
			enemy_value += 1
			$Performance_Hbox / Performance_Scroll / Performance_Vbox / Enemies_Label.text = "Enemies: " + str(enemy_value, "/", Global.enemy_count_total)
			var color = float(enemy_value) / float(Global.enemy_count_total)
			$Performance_Hbox / Performance_Scroll / Performance_Vbox / Enemies_Label.add_color_override("font_color", Color(1 - color, color, 0).from_hsv(color * 0.25, 1, 1))
		elif civ_value < Global.civ_count_total - Global.civ_count:
			civ_value += 1
			var color = float(civ_value) / float(Global.civ_count_total)
			$Performance_Hbox / Performance_Scroll / Performance_Vbox / Civilians_Label.add_color_override("font_color", Color(1 - color, color, 0).from_hsv(color * 0.25, 1, 1))
			$Performance_Hbox / Performance_Scroll / Performance_Vbox / Civilians_Label.text = "Civilians: " + str(civ_value, "/", Global.civ_count_total)
		else :
			active = false
			enemy_value = 0
			civ_value = 0
			
