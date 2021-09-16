extends Spatial

func player_use():
		Global.objectives = 0
		Global.objective_complete = false
		Global.civ_count = 0
		Global.enemy_count = 0
		Global.enemy_count_total = 0
		Global.civ_count_total = 0
		Global.save_game()
		Global.menu.in_game = false
		Global.goto_scene("res://Menu/Main_Menu.tscn")
		Global.menu.show()
		Global.menu._on_Start_Button_Pressed(0, Global.menu.menu[0].get_child(0))
		Global.menu.hide_buttons(Global.menu.menu[Global.menu.START], 2, 4)
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
